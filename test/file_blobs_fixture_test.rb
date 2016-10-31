require_relative 'test_helper'

class FileBlobsFixtureTest < ActiveSupport::TestCase
  setup do
    @ruby = FileBlob.where(id: file_blob_id('files/ruby.png')).first
    @invoice = FileBlob.where(id: file_blob_id('files/invoice.pdf')).first

    @ruby_path = File.expand_path '../fixtures/files/ruby.png', __FILE__
    @invoice_path = File.expand_path '../fixtures/files/invoice.pdf', __FILE__
  end

  test 'ruby fixture' do
    assert @ruby
    assert_equal file_blob_data('files/ruby.png'), @ruby.data
  end

  test 'invoice fixture' do
    assert @invoice
    assert_equal file_blob_data('files/invoice.pdf'), @invoice.data
  end
end
