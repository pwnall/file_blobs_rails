require_relative 'test_helper'

class BlobModelTest < ActiveSupport::TestCase
  setup do
    blob_data = 'Hello blob world!'
    @blob = GemTestBlob.new data: blob_data,
                            id: GemTestBlob.id_for('blob_data')
  end

  test 'setup' do
    assert @blob.valid?, @blob.errors
  end

  test 'requires an id' do
    @blob.id = nil
    assert !@blob.valid?
  end

  test 'requires data' do
    @blob.data = nil
    assert !@blob.valid?
  end
end
