require 'active_record'

module FileBlobs

# Module mixed into ActiveRecord::ConnectionAdapters::TableDefinition.
module ActiveRecordTableDefinitionExtensions
  # Creates the columns used to reference a file blob
  #
  # @param [Symbol] column_name_base the prefix used to generate column names;
  #     this should match the attribute name given to has_file_blob
  # @param [Hash<Symbol, Object>] options
  # @option options [Boolean] null true
  # @option options [Integer] mime_type_limit the maximum size of the column
  #     used to store the file name provided by the user's browser
  # @option options [Integer] file_name_limit the maximum size of the column
  #     used to store the file blob's MIME type
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
