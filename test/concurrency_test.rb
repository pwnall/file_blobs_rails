require_relative 'test_helper'

class ConcurrencyTest < ActiveSupport::TestCase
  test 'new blob created sequentially by two models' do
    owner1 = BlobOwner.new file_data: 'file data', file_mime_type: 'text/plain',
                           file_original_name: 'file.txt'
    owner1.save!
    owner2 = BlobOwner.new file_data: 'file data', file_mime_type: 'text/x-o',
                           file_original_name: 'x-o.txt'
    owner2.save!
    assert_equal 'file data', owner1.file_data
    assert_equal 'text/plain', owner1.file_mime_type
    assert_equal 'file.txt', owner1.file_original_name
    assert_equal 'file data', owner2.file_data
    assert_equal 'text/x-o', owner2.file_mime_type
    assert_equal 'x-o.txt', owner2.file_original_name
  end

  test 'new blob created at the same time by two models' do
    owner1 = BlobOwner.new file_data: 'file data', file_mime_type: 'text/plain',
                           file_original_name: 'file.txt'
    owner2 = BlobOwner.new file_data: 'file data', file_mime_type: 'text/x-o',
                           file_original_name: 'x-o.txt'

    owner1.save!
    owner2.save!
    assert_equal 'file data', owner1.file_data
    assert_equal 'text/plain', owner1.file_mime_type
    assert_equal 'file.txt', owner1.file_original_name
    assert_equal 'file data', owner2.file_data
    assert_equal 'text/x-o', owner2.file_mime_type
    assert_equal 'x-o.txt', owner2.file_original_name
  end

  test 'new blob deleted and referenced sequentially by two models' do
    owner1 = BlobOwner.new file_data: 'file data', file_mime_type: 'text/plain',
                           file_original_name: 'file.txt'
    owner1.save!
    owner1.destroy

    owner2 = BlobOwner.new file_data: 'file data', file_mime_type: 'text/x-o',
                           file_original_name: 'x-o.txt'
    owner2.save!
    assert_equal 'file data', owner2.file_data
    assert_equal 'text/x-o', owner2.file_mime_type
    assert_equal 'x-o.txt', owner2.file_original_name
  end

  test 'new blob deleted in one model and referenced in another at same time' do
    owner1 = BlobOwner.new file_data: 'file data', file_mime_type: 'text/plain',
                           file_original_name: 'file.txt'
    owner1.save!

    owner2 = BlobOwner.new file_data: 'file data', file_mime_type: 'text/x-o',
                           file_original_name: 'x-o.txt'
    owner1.destroy
    owner2.save!
    assert_equal 'file data', owner2.file_data
    assert_equal 'text/x-o', owner2.file_mime_type
    assert_equal 'x-o.txt', owner2.file_original_name
  end
end
