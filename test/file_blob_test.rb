require_relative 'test_helper'

# Run the tests in the generator, to make sure they pass.
template_path = File.expand_path(
    '../../lib/file_blobs_rails/generators/templates/file_blob_test.rb.erb',
    __FILE__)
eval Erubis::Eruby.new(File.read(template_path)).result(
    file_name: 'file_blob'), nil, template_path
