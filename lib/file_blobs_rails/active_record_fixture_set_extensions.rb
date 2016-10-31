require 'base64'

require 'active_record/fixtures'

module FileBlobs

# Module mixed into ActiveRecord::FixtureSet.
module ActiveRecordFixtureSetExtensions
  # Computes the ID assigned to a blob.
  #
  # @param [String] path the path of the file whose contents is used in the
  #   fixture, relative to the Rails application's test/fixtures directory
  # @return [String] the ID used to represent the blob contents
  def file_blob_id(path)
    file_path = Rails.root.join('test/fixtures'.freeze).join(path)
    blob_contents = File.binread file_path

    # This needs to be kept in sync with blob_model.rb.
    Base64.urlsafe_encode64(Digest::SHA256.digest(blob_contents)).inspect
  end

  # The contents of a blob, in a YAML-friendly format.
  #
  # @param [String] path the path of the file whose contents is used in the
  #   fixture, relative to the Rails application's test/fixtures directory
  # @param [Hash] options optionally specify the current indentation level
  # @option options [Integer] indent the number of spaces that the current line
  #   in the YAML fixture file is indented by
  # @return [String] the base64-encoded blob contents
  def file_blob_data(path, options = {})
    # The line with base64 data must be indented further than the current line.
    indent = ' ' * ((options[:indent] || 2) + 2)

    file_path = Rails.root.join('test/fixtures'.freeze).join(path)
    blob_contents = File.binread file_path
    base64_data = Base64.encode64 blob_contents
    base64_data.gsub! "\n", "\n#{indent}"
    base64_data.strip!

    "!!binary |\n#{indent}#{base64_data}"
  end

  # The number of bytes in a file.
  #
  # @param [String] path the path of the file whose contents is used in the
  #   fixture, relative to the Rails application's test/fixtures directory
  # @return [Integer] the nubmer of bytes in the file
  def file_blob_size(path)
    file_path = Rails.root.join('test/fixtures'.freeze).join(path)
    File.stat(file_path).size
  end
end  # module FileBlobs::ActiveRecordFixtureSetExtensions

end  # namespace FileBlobs

ActiveRecord::FixtureSet.context_class.class_eval do
  include FileBlobs::ActiveRecordFixtureSetExtensions
end
