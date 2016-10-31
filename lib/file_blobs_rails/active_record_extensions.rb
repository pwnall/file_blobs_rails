require 'active_record'
require 'active_support'

module FileBlobs

# Module mixed into ActiveRecord::Base.
module ActiveRecordExtensions
  extend ActiveSupport::Concern
end  # module FileBlobs::ActiveRecordExtensions

module ActiveRecordExtensions::ClassMethods
  # Creates a reference to a FileBlob storing a file.
  #
  # `has_file_blob :file` creates the following
  #
  # * file - synthetic accessor
  # * file_blob - belongs_to relationship pointing to a FileBlob
  # * file_blob_id - attribute used by the belongs_to relationship; stores the
  #   SHA-256 of the file's contents
  # * file_size - attribute storing the file's length in bytes; this is stored
  #   in the model as an optimization, so the length can be displayed / used
  #   for decisions without fetching the blob model storing the contents
  # * file_mime_type - attribute storing the MIME type associated with the
  #   file; this is stored outside the blob model because it is possible to
  #   have the same bytes uploaded with different MIME types
  # * file_original_name - attribute storing the name supplied by the browser
  #   that uploaded the file; this should not be trusted, as it is controlled
  #   by the user
  #
  # @param [String] attribute_name the name of the relationship pointing to the
  #     file blob, and the root of the names of the related attributes
  # @param [Hash{Symbol, Object}] options
  # @option options [String] blob_model the name of the model used to store the
  #     file's contents; defaults to 'FileBlob'
  # @option options [Boolean] allow_nil if true, allows saving a model without
  #     an associated file
  def has_file_blob(attribute_name = 'file', options = {})
    blob_model = (options[:blob_model] || 'FileBlob'.freeze).to_s
    allow_nil = options[:allow_nil] || false

    self.class_eval <<ENDRUBY, __FILE__, __LINE__ + 1
      # Saves the old blob model id, so the de-referenced blob can be GCed.
      before_save :#{attribute_name}_stash_old_blob, on: :update

      # Checks if the de-referenced FileBlob in an update should be GCed.
      after_update :#{attribute_name}_maybe_garbage_collect_old_blob

      # Checks if the FileBlob of a deleted entry should be GCed.
      after_destroy :#{attribute_name}_maybe_garbage_collect_blob

      # The FileBlob storing the file's content.
      belongs_to :#{attribute_name}_blob,
          { class_name: #{blob_model.inspect} }, -> { select :id }

      class #{attribute_name.to_s.classify}Proxy < FileBlobs::FileBlobProxy
        # Creates a proxy for the given model.
        #
        # The proxied model remains constant for the life of the proxy.
        def initialize(owner)
          @owner = owner
        end

        # Virtual attribute that proxies to the model's _blob attribute.
        #
        # This attribute does not have a corresponding setter because a _blob
        # setter would encourage sub-optimal code. The owner model's file blob
        # setter should be used instead, as it has a fast path that avoids
        # fetching the blob's data. By comparison, a _blob setter would always
        # have to fetch the blob data, to determine the blob's size.
        def blob
          @owner.#{attribute_name}_blob
        end

        # Virtual attribute that proxies to the model's _mime_type attribute.
        def mime_type
          @owner.#{attribute_name}_mime_type
        end
        def mime_type=(new_mime_type)
          @owner.#{attribute_name}_mime_type = new_mime_type
        end

        # Virtual attribute that proxies to the model's _original_name attribute.
        def original_name
          @owner.#{attribute_name}_original_name
        end
        def original_name=(new_name)
          @owner.#{attribute_name}_original_name = new_name
        end

        # Virtual getter that proxies to the model's _size attribute.
        #
        # This attribute does not have a corresponding setter because the _size
        # attribute automatically tracks the _data attribute, so it should not
        # be set on its own.
        def size
          @owner.#{attribute_name}_size
        end

        # Virtual attribute that proxies to the model's _blob_id attribute.
        #
        # This attribute is an optimization that allows some code paths to
        # avoid fetching the associated blob model. It should only be used in
        # these cases.
        #
        # This attribute does not have a corresponding setter because the
        # contents blob should be set using the model's _blob attribute (with
        # the blob proxy), which updates the model _size attribute and checks
        # that the blob is an instance of the correct blob model.
        def blob_id
          @owner.#{attribute_name}_blob_id
        end

        # Virtual attribute that proxies to the model's _data attribute.
        def data
          @owner.#{attribute_name}_data
        end
        def data=(new_data)
          @owner.#{attribute_name}_data = new_data
        end

        # Reflection.
        def blob_class
          #{blob_model}
        end
        def allows_nil?
          #{allow_nil}
        end
        attr_reader :owner
      end

      # Getter for the file's convenience proxy.
      def #{attribute_name}
        @_#{attribute_name}_proxy ||=
            #{attribute_name.to_s.classify}Proxy.new self
      end

      # Convenience setter for all the file attributes.
      #
      # @param {ActionDispatch::Http::UploadedFile, Proxy} new_file either an
      #     object representing a file uploaded to a controller, or an object
      #     obtained from another model's blob accessor
      def #{attribute_name}=(new_file)
        if new_file.respond_to? :read
          # ActionDispatch::Http::UploadedFile
          self.#{attribute_name}_mime_type = new_file.content_type
          self.#{attribute_name}_original_name = new_file.original_filename
          self.#{attribute_name}_data = new_file.read
        elsif new_file.respond_to? :blob_class
          # Blob owner proxy.
          self.#{attribute_name}_mime_type = new_file.mime_type
          self.#{attribute_name}_original_name = new_file.original_name
          if new_file.blob_class == #{blob_model}
            # Fast path: when the two files are backed by the same blob table,
            # we can create a new reference to the existing blob.
            self.#{attribute_name}_blob_id = new_file.blob_id
            self.#{attribute_name}_size = new_file.size
          else
            # Slow path: we need to copy data across blob tables.
            self.#{attribute_name}_data = new_file.data
          end
        end
      end

      # Convenience getter for the file's content.
      #
      # @return [String] a string with the binary encoding that holds the
      #     file's contents
      def #{attribute_name}_data
        # NOTE: we're not using the ActiveRecord association on purpose, so
        #       that the large FileBlob doesn't hang off of the object
        #       referencing it; this way, the blob's data can be
        #       garbage-collected by the Ruby VM as early as possible
        blob = #{blob_model}.where(id: #{attribute_name}_blob_id).first!
        blob.data
      end

      # Convenience setter for the file's content.
      #
      # @param new_blob_contents [String] a string with the binary encoding
      #     that holds the new file contents to be stored by this model
      def #{attribute_name}_data=(new_blob_contents)
        sha = new_blob_contents && #{blob_model}.id_for(new_blob_contents)
        return if self.#{attribute_name}_blob_id == sha

        if sha && #{blob_model}.where(id: sha).length == 0
          self.#{attribute_name}_blob = #{blob_model}.new id: sha,
              data: new_blob_contents
        else
          self.#{attribute_name}_blob_id = sha
        end

        self.#{attribute_name}_size =
            new_blob_contents && new_blob_contents.bytesize
      end

      # Saves the old blob model id, so the de-referenced blob can be GCed.
      def #{attribute_name}_stash_old_blob
        @_#{attribute_name}_old_blob_id = #{attribute_name}_blob_id_change &&
            #{attribute_name}_blob_id_change.first
      end
      private :#{attribute_name}_stash_old_blob

      # Checks if the de-referenced blob model in an update should be GCed.
      def #{attribute_name}_maybe_garbage_collect_old_blob
        return unless @_#{attribute_name}_old_blob_id
        old_blob = #{blob_model}.find @_#{attribute_name}_old_blob_id
        old_blob.maybe_garbage_collect
        @_#{attribute_name}_old_blob_id = nil
      end
      private :#{attribute_name}_maybe_garbage_collect_old_blob

      # Checks if the FileBlob of a deleted entry should be GCed.
      def #{attribute_name}_maybe_garbage_collect_blob
        #{attribute_name}_blob && #{attribute_name}_blob.maybe_garbage_collect
      end
      private :#{attribute_name}_maybe_garbage_collect_blob

      unless self.respond_to? :file_blob_id_attributes
        @@file_blob_id_attributes = {}
        cattr_reader :file_blob_id_attributes, instance_reader: false
      end

      unless self.respond_to? :file_blob_eligible_for_garbage_collection?
        # Checks if a contents blob is referenced by a model of this class.
        #
        # @param {FileBlobs::BlobModel} file_blob a blob to be checked
        def self.file_blob_eligible_for_garbage_collection?(file_blob)
          attributes = file_blob_id_attributes[file_blob.class.name]
          file_blob_id = file_blob.id

          # TODO(pwnall): Use or to issue a single SQL query for multiple
          #     attributes.
          !attributes.any? do |attribute|
            where(attribute => file_blob_id).exists?
          end
        end
      end
ENDRUBY

    file_blob_id_attributes[blob_model] ||= []
    file_blob_id_attributes[blob_model] << :"#{attribute_name}_blob_id"

    if !allow_nil
      self.class_eval <<ENDRUBY, __FILE__, __LINE__ + 1
        validates :#{attribute_name}_blob, presence: true
        validates :#{attribute_name}_mime_type, presence: true
        validates :#{attribute_name}_size, presence: true
ENDRUBY
    end
  end
end  # module FileBlobs::ActiveRecordExtensions::ClassMethods

end  # namespace FileBlobs

ActiveRecord::Base.class_eval do
  include FileBlobs::ActiveRecordExtensions
end
