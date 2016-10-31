ActiveRecord::Migration.verbose = false

# Simulate Rails' db:migrate.

template = File.read File.expand_path(
    '../../../lib/file_blobs_rails/generators/templates/001_create_file_blobs.rb.erb',
    __FILE__)
eval Erubis::Eruby.new(template).result(file_name: 'file_blob')
CreateFileBlobs.migrate :up

template = File.read File.expand_path(
    '../../../lib/file_blobs_rails/generators/templates/002_create_blob_owners.rb.erb',
    __FILE__)
eval Erubis::Eruby.new(template).result(file_name: 'blob_owner',
    options: { allow_nil: false, attr_name: 'file', blob_model: 'FileBlob' })
CreateBlobOwners.migrate :up

require_relative(
    '../fixtures/003_create_gem_test_blobs.rb')
CreateGemTestBlobs.migrate :up
require_relative(
    '../fixtures/004_create_gem_test_messages.rb')
CreateGemTestMessages.migrate :up

# Simulate Rails' autoloading.

template_path = File.expand_path(
    '../../../lib/file_blobs_rails/generators/templates/file_blob.rb.erb',
    __FILE__)
eval Erubis::Eruby.new(File.read(template_path)).result(
    file_name: 'file_blob'), nil, template_path

template_path = File.expand_path(
    '../../../lib/file_blobs_rails/generators/templates/blob_owner.rb.erb',
    __FILE__)
eval Erubis::Eruby.new(File.read(template_path)).result(
    file_name: 'blob_owner', options: { allow_nil: false, attr_name: 'file',
    blob_model: 'FileBlob' }), nil, template_path

require_relative '../fixtures/gem_test_blob.rb'
require_relative '../fixtures/gem_test_message.rb'
