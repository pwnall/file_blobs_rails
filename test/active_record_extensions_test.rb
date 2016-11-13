require_relative 'test_helper'

class ActiveRecordExtensionsTest < ActiveSupport::TestCase
  setup do
    @blob_owner = blob_owners(:ruby)
  end

  test 'referenced blob validation' do
    @blob_owner.file.data = ' ' * 1.megabyte
    assert !@blob_owner.valid?
    assert_not_empty @blob_owner.errors[:file_blob]
  end
end
