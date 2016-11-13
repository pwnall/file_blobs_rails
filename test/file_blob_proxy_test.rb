require_relative 'test_helper'

class FileBlobProxyTest < ActiveSupport::TestCase
  setup do
    @blob_owner = blob_owners(:ruby)
    @message = GemTestMessage.new
  end

  test '#blob_class' do
    assert_equal FileBlob, @blob_owner.file.blob_class
    assert_equal GemTestBlob, @message.attachment.blob_class
  end

  test '#allow_nil?' do
    assert_equal false, @blob_owner.file.allow_nil?
    assert_equal true, @message.attachment.allow_nil?
  end

  test '#owner' do
    assert_equal @blob_owner, @blob_owner.file.owner
    assert_equal @message, @message.attachment.owner
  end

  test 'proxy getter on the owner model' do
    proxy = @blob_owner.file

    assert_kind_of FileBlobs::FileBlobProxy, proxy
  end

  test 'getter proxies' do
    proxy = @blob_owner.file

    assert_equal 'image/png', proxy.mime_type
    assert_equal 'ruby.png', proxy.original_name
    assert_equal file_blob_id('files/ruby.png'), proxy.blob_id
    assert_equal file_blob_size('files/ruby.png'), proxy.size
    assert_equal file_blob_data('files/ruby.png'), proxy.data
    assert_equal file_blobs(:ruby_png), proxy.blob
  end

  test '#mime_type=' do
    proxy = @blob_owner.file
    proxy.mime_type = 'x-test/x-setter'

    assert_equal 'x-test/x-setter', proxy.mime_type
    assert_equal 'ruby.png', proxy.original_name
    assert_equal file_blob_id('files/ruby.png'), proxy.blob_id
    assert_equal file_blob_size('files/ruby.png'), proxy.size
    assert_equal file_blob_data('files/ruby.png'), proxy.data
    assert_equal file_blobs(:ruby_png), proxy.blob
  end

  test '#original_name=' do
    proxy = @blob_owner.file
    proxy.original_name = 'setter-test.png'

    assert_equal 'image/png', proxy.mime_type
    assert_equal 'setter-test.png', proxy.original_name
    assert_equal file_blob_id('files/ruby.png'), proxy.blob_id
    assert_equal file_blob_size('files/ruby.png'), proxy.size
    assert_equal file_blob_data('files/ruby.png'), proxy.data
    assert_equal file_blobs(:ruby_png), proxy.blob
  end

  test '#data=' do
    proxy = @blob_owner.file
    proxy.data = file_blob_data('files/invoice.pdf')

    assert_equal 'image/png', proxy.mime_type
    assert_equal 'ruby.png', proxy.original_name
    assert_equal file_blob_id('files/invoice.pdf'), proxy.blob_id
    assert_equal file_blob_size('files/invoice.pdf'), proxy.size
    assert_equal file_blob_data('files/invoice.pdf'), proxy.data
    assert_equal file_blobs(:invoice_pdf), proxy.blob
  end

  test 'proxy setter on the owner model with same-table blobs' do
    new_blob_owner = BlobOwner.new file: @blob_owner.file

    assert_equal 'ruby.png', new_blob_owner.file_original_name
    assert_equal file_blob_id('files/ruby.png'), new_blob_owner.file_blob_id
    assert_equal file_blob_size('files/ruby.png'), new_blob_owner.file_size
    assert_equal file_blob_data('files/ruby.png'), new_blob_owner.file_data
    assert_equal file_blobs(:ruby_png), new_blob_owner.file_blob
  end

  test 'proxy setter on the owner model with different-table blobs' do
    @message.attachment = @blob_owner.file

    assert_equal 'ruby.png', @message.attachment_original_name
    assert_equal file_blob_id('files/ruby.png'), @message.attachment_blob_id
    assert_equal file_blob_size('files/ruby.png'), @message.attachment_size

    assert_instance_of GemTestBlob, @message.attachment_blob
    assert_equal file_blob_id('files/ruby.png'), @message.attachment_blob.id
    assert_equal file_blob_data('files/ruby.png'),
                 @message.attachment_blob.data
    assert_equal true, @message.attachment_blob.new_record?
  end

  test 'proxy setter on the owner model with nil' do
    @blob_owner.file = nil

    assert_equal nil, @blob_owner.file_original_name
    assert_equal nil, @blob_owner.file_blob_id
    assert_equal nil, @blob_owner.file_size
    assert_equal nil, @blob_owner.file_data
    assert_equal nil, @blob_owner.file_blob
  end

  test 'proxy setter on the owner model with an invalid value' do
    exception = assert_raise ArgumentError do
      @blob_owner.file = [4, 2]
    end
    assert_equal 'Invalid file_blob value: [4, 2]', exception.message

    assert_equal 'ruby.png', @blob_owner.file_original_name
    assert_equal file_blob_id('files/ruby.png'), @blob_owner.file_blob_id
    assert_equal file_blob_size('files/ruby.png'), @blob_owner.file_size
    assert_equal file_blob_data('files/ruby.png'), @blob_owner.file_data
    assert_equal file_blobs(:ruby_png), @blob_owner.file_blob
  end
end
