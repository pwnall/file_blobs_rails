require 'active_support/dependencies'

module FileBlobs
  extend ActiveSupport::Autoload

  autoload :BlobModel, 'file_blobs_rails/blob_model.rb'
  autoload :FileBlobProxy, 'file_blobs_rails/file_blob_proxy.rb'
end  # module FileBlobs

require_relative(
    'file_blobs_rails/action_controller_data_streaming_extensions.rb')
require_relative 'file_blobs_rails/active_record_extensions.rb'
require_relative 'file_blobs_rails/active_record_fixture_set_extensions.rb'
require_relative 'file_blobs_rails/active_record_migration_extensions.rb'
require_relative(
    'file_blobs_rails/active_record_table_definition_extensions.rb')
require_relative 'file_blobs_rails/active_support_test_extensions.rb'

if defined?(Rails)
  require_relative 'file_blobs_rails/engine.rb'
end
