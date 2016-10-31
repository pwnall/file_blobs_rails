require_relative 'test_helper'

# Run the tests in the generator, to make sure they pass.
template_path = File.expand_path(
    '../../lib/file_blobs_rails/generators/templates/blob_owner_test.rb.erb',
    __FILE__)
eval Erubis::Eruby.new(File.read(template_path)).result(
    options: { attr_name: 'file', allow_nil: false, blob_model: 'FileBlob' },
    file_name: 'blob_owner'), nil, template_path
