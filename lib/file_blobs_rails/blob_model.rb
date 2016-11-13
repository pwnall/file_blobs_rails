require 'base64'
require 'digest/sha2'

require 'active_model'
require 'active_support'

module FileBlobs

# Included in the model that stores file data.
module BlobModel
  extend ActiveSupport::Concern

  included do
    # A cryptographic hash over the file's data.
    #
    # This will be an URL-safe string.
    validates :id, presence: true, length: 1..48, uniqueness: true

    # The raw data in the file.
    validates :data, presence: true
    validates_each :data do |record, attr, value|
      data_limit = record.class.column_for_attribute(:data).limit
      if data_limit && value && value.bytesize > data_limit
        record.errors.add attr, 'is too large'.freeze
      end
    end
  end

  # Class methods on models that include FileBlobsRails::BlobModel.
  module ClassMethods
    # The URL-safe base64-encoded SHA-256 of the given data.
    #
    # @param [String] blob_contents the file data to be hashed
    # @return [String] a cryptographically strong hash of the given data
    def id_for(blob_contents)
      # This needs to be kept in sync with
      # active_record_fixture_set_extensions.rb.
      Base64.urlsafe_encode64 Digest::SHA256.digest(blob_contents)
    end

    # Declares the model classes that use `has_file_blob`.
    #
    # This list is necessary for garbage collection to work correctly. If the
    # class list is incomplete, a blob model may be garbage-collected
    # prematurely.
    #
    # @param [Enumerable<String>] class_names the names of the model classes
    #     that include the HasFileBlob concern, and therefore point to the
    #     file blob model (the class that includes FileBlobsRails::BlobModel)
    def blob_owner_class_names!(*class_names)
      # We're using map to create a new array out of the class_list parameter,
      # which can be any iterable.
      #
      # We're not particularly concerned with speed, because this is executed
      # once in production, while the application boots. Also, the class_names
      # array is expected to be small.
      @_blob_owner_class_names ||=
          class_names.map { |class_name| class_name.to_s }.freeze
    end

    # The classes that include FileBlobsRails::HasFileBlob.
    #
    # @return [Array<Class>] the model classes
    def blob_owner_classes
      @_blob_owner_classes ||= @_blob_owner_class_names.map do |class_name|
        # Trigger ActiveSupport's autoloading behavior.
        #
        # ActiveSupport's String#constantize is pretty slow, but we're not
        # particularly concerned with speed, because this is executed once in
        # production, while the application boots. Also, the list of class
        # names is expected to be small.
        class_name.constantize
      end.freeze
    end
  end

  # Garbage-collects this blob if it is not referenced by any other model.
  #
  # @return [Boolean] true if the blob was garbage-collected
  def maybe_garbage_collect
    self.class.transaction do
      if eligible_for_garbage_collection?
        destroy
        true
      else
        false
      end
    end
  end

  # Checks if this blob can be garbage-collected.
  #
  # This check's result can become invalid after another Blob-owning model is
  # created. To prevent data races, the check and its corresponding garbage
  # collection must be done in the same database transaction.
  #
  # @return [Boolean] true if this blob is not referenced by any Blob-owning
  #     model, and thus is eligible for garbage collection
  def eligible_for_garbage_collection?
    self.class.blob_owner_classes.all? do |klass|
      klass.file_blob_eligible_for_garbage_collection? self
    end
  end
end  # module FileBlobs::BlobModel

end  # namespace FileBlobs
