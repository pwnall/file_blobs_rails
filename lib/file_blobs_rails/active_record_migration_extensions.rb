require 'active_record'

module FileBlobs

# Module mixed into ActiveRecord::Migration.
module ActiveRecordMigrationExtensions
  # Creates the table used to hold file blobs.
  #
  # @param [Symbol] table_name the name of the table used to hold file data
  # @param [Hash<Symbol, Object>] options
  # @option options [Integer] blob_limit the maximum file size that can be
  #     stored in the table; defaults to 1 megabyte
  def create_file_blobs_table(table_name = :file_blobs, options = {}, &block)
    blob_limit = options[:blob_limit] || 1.megabyte

    create_table table_name, id: false do |t|
      t.primary_key :id, :string, null: false, limit: 48
      t.binary :data, null: false, limit: blob_limit

      # Block capturing and calling is a bit slower than using yield. This is
      # not a concern because migrations aren't run in tight loops.
      block.call t
    end
  end
end  # module FileBlobs::ActiveRecordMigrationExtensions

end  # namespace FileBlobs

ActiveRecord::Migration.class_eval do
  include FileBlobs::ActiveRecordMigrationExtensions
end
