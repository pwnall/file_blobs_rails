module FileBlobs

class BlobOwnerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  check_class_collision

  class_option :attr_name, type: :string, default: 'file',
      desc: 'The name of the attribute pointing to the blob model'
  class_option :blob_model, type: :string, default: 'FileBlob',
      desc: 'The name of the model class that stores the file contents'
  class_option :allow_nil, type: :boolean, default: false,
      desc: "Support models that don't store files"

  def create_file_blob_model
    # Set up the template environment.
    template 'blob_owner.rb.erb', File.join('app', 'models', "#{file_name}.rb")
    template 'blob_owner_test.rb.erb',
             File.join('test', 'models', "#{file_name}_test.rb")
    template '002_create_blob_owners.rb.erb',
        File.join('db', 'migrate',
                  "20161029000002_create_#{file_name.tableize}.rb")
    template 'blob_owners.yml.erb',
             File.join('test', 'fixtures', "#{file_name.tableize}.yml")
  end
end  # class FileBlobs::BlobModelGenerator

end  # namespace FileBlobs
