require_relative 'test_helper'

class GarbageCollectionTest < ActiveSupport::TestCase
  test 'new blob with no reference gets garbage-collected' do
    BlobOwner.destroy_all
    FileBlob.destroy_all

    blob = FileBlob.create! data: 'hello world',
                            id: FileBlob.id_for('hello world')

    assert_equal true,
        BlobOwner.file_blob_eligible_for_garbage_collection?(blob)

    assert_equal true, blob.eligible_for_garbage_collection?

    assert_difference -> { FileBlob.count }, -1 do
      assert_equal true, blob.maybe_garbage_collect
    end
    assert_equal nil, FileBlob.where(id: blob.id).first
  end

  test 'blob with a reference does not get garbage-collected' do
    blob = file_blobs(:ruby_png)

    assert_equal false,
        BlobOwner.file_blob_eligible_for_garbage_collection?(blob)
    assert_equal false, blob.eligible_for_garbage_collection?
    assert_no_difference -> { FileBlob.count } do
      assert_equal false, blob.maybe_garbage_collect
    end
  end

  test 'blob with one owner gets collected when owner gets destroyed' do
    owner = blob_owners(:ruby)
    blob = file_blobs(:ruby_png)

    assert_difference -> { FileBlob.count }, -1 do
      owner.destroy
    end

    assert_equal nil, FileBlob.where(id: blob.id).first
  end

  test 'blob with two owners is not collected when an owner gets destroyed' do
    owner = blob_owners(:ruby)
    new_owner = BlobOwner.create! file: owner.file
    assert_equal owner.file_blob, new_owner.file_blob, 'Incorrect test setup'

    blob = file_blobs(:ruby_png)

    assert_no_difference -> { FileBlob.count } do
      owner.destroy
    end

    assert_equal blob, FileBlob.where(id: blob.id).first
  end

  test 'blob with a reference gets garbage-collected when reference changes' do
    owner = blob_owners(:ruby)
    dead_blob = file_blobs(:ruby_png)
    live_blob = file_blobs(:invoice_pdf)

    owner.file_blob = live_blob

    # First check that the blob doesn't get garbage-collected until the owner
    # gets saved.
    assert_equal false,
        BlobOwner.file_blob_eligible_for_garbage_collection?(dead_blob)
    assert_equal false, dead_blob.eligible_for_garbage_collection?
    assert_no_difference -> { FileBlob.count } do
      assert_equal false, dead_blob.maybe_garbage_collect
    end

    # Now check that the blob gets garbage-collected when the reference change
    # is committed.

    assert_difference -> { FileBlob.count }, -1 do
      owner.save!
    end

    assert_equal nil, FileBlob.where(id: dead_blob.id).first
    assert_equal live_blob, FileBlob.where(id: live_blob.id).first
  end
end
