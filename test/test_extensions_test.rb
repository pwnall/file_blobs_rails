require_relative 'test_helper'

class TestExtensionsTest < ActiveSupport::TestCase
  setup do
    @ruby_path = File.expand_path '../fixtures/files/ruby.png', __FILE__
    @invoice_path = File.expand_path '../fixtures/files/invoice.pdf', __FILE__
  end

  test 'file_blob_data' do
    assert_equal File.binread(@ruby_path), file_blob_data('files/ruby.png')
    assert_equal File.binread(@invoice_path),
                  file_blob_data('files/invoice.pdf')
  end

  test 'file_blob_id' do
    assert_equal 'udXLga6YgZX7TR__OGt6NGw2u4ulhODFWndwUlwPoXU=',
                 file_blob_id('files/ruby.png')
    assert_equal '30aM5cShJnhiJJCLahmhdWjk31Cq9d7hKoIHiEf2VbM=',
                 file_blob_id('files/invoice.pdf')
  end
end
