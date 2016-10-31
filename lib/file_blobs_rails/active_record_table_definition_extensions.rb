require 'active_record'

module FileBlobs

# Module mixed into ActiveRecord::ConnectionAdapters::TableDefinition.
module ActiveRecordTableDefinitionExtensions
  # Creates the table used to hold file blobs.
  #
  # @param [Symbol] table_name the name of the table used to hold file data
  # @param [Hash<Symbol, Object>] options
  # @option options [Boolean] null true
  # @option options [Integer] blob_limit the maximum file size that can be
  #     stored in the table; defaults to 1 megabyte
  def file_blob(column_name_base = :file, options = {}, &block)
    allow_null = options[:null] || false
    mime_type_limit = options[:mime_type_limit] || 64
    file_name_limit = options[:file_name_limit] || 256

    # The index is needed for garbage-collection eligibility checks.
    string :"#{column_name_base}_blob_id", limit: 48, null: allow_null,
           index: true

    integer :"#{column_name_base}_size", null: allow_null
    string :"#{column_name_base}_mime_type", limit: mime_type_limit,
           null: allow_null
    string :"#{column_name_base}_original_name", limit: file_name_limit,
           null: allow_null
  end
end  # module FileBlobs::ActiveRecordTableDefinitionExtensions

end  # namespace FileBlobs

ActiveRecord::ConnectionAdapters::TableDefinition.class_eval do
  include FileBlobs::ActiveRecordTableDefinitionExtensions
end
