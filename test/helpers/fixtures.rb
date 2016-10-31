require 'fileutils'

# Simulate generating the fixtures.

FileUtils.mkdir_p File.expand_path('../../../tmp/files', __FILE__)

template_path = File.expand_path(
    '../../../lib/file_blobs_rails/generators/templates/file_blobs.yml.erb',
    __FILE__)
output = Erubis::Eruby.new(File.read(template_path)).result(
    file_name: 'file_blob')
File.write File.expand_path('../../../tmp/file_blobs.yml', __FILE__), output

template_path = File.expand_path(
    '../../../lib/file_blobs_rails/generators/templates/blob_owners.yml.erb',
    __FILE__)
output = Erubis::Eruby.new(File.read(template_path)).result(
    file_name: 'blob_owner', options: { allow_nil: false, attr_name: 'file',
    blob_model: 'FileBlob' })
File.write File.expand_path('../../../tmp/blob_owners.yml', __FILE__), output

FileUtils.cp File.expand_path(
    '../../../lib/file_blobs_rails/generators/templates/files/invoice.pdf',
    __FILE__), File.expand_path('../../../tmp/files', __FILE__)
FileUtils.cp File.expand_path(
    '../../../lib/file_blobs_rails/generators/templates/files/ruby.png',
    __FILE__), File.expand_path('../../../tmp/files', __FILE__)


# This needs to happen after the fixture files are created.

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures

  self.fixture_path = File.expand_path('../../../tmp', __FILE__)

  self.use_transactional_tests = true
  self.use_instantiated_fixtures = false
  self.pre_loaded_fixtures = false
  fixtures :all
end
