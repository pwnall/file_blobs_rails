require 'base64'

require 'active_support'

module FileBlobs

# Module mixed into ActiveRecord::FixtureSet.
module ActiveSupportTestFixtures
  # The contents of a blob.
  #
  # @param [String] path the path of the file whose contents is used in the
  #   fixture, relative to the Rails application's test/fixtures directory
  # @return [String] the blob contents
  def file_blob_data(path)
    file_path = Rails.root.join('test/fixtures'.freeze).join(path)
    File.binread file_path
  end

  # Computes the ID assigned to a blob.
  #
  # @param [String] path the path of the file whose contents is used in the
  #   fixture, relative to the Rails application's test/fixtures directory
  # @return [String] the ID used to represent the blob contents
  def file_blob_id(path)
    # This needs to be kept in sync with blob_model.rb.
    Base64.urlsafe_encode64(Digest::SHA256.digest(file_blob_data(path)))
  end

  # The size of a blob.
  #
  # @param [String] path the path of the file whose contents is used in the
  #   fixture, relative to the Rails application's test/fixtures directory
  # @return [String] the blob contents
  def file_blob_size(path)
    file_path = Rails.root.join('test/fixtures'.freeze).join(path)
    File.stat(file_path).size
  end
end  # module FileBlobs::ActiveSupportTestFixtures

end  # namespace FileBlobs

ActiveSupport::TestCase.class_eval do
  include FileBlobs::ActiveSupportTestFixtures
end
