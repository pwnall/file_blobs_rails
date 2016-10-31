module FileBlobs

class BlobModelGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  check_class_collision

  def create_file_blob_model
    template 'file_blob.rb.erb', File.join('app', 'models', "#{file_name}.rb")
    template 'file_blob_test.rb.erb',
             File.join('test', 'models', "#{file_name}_test.rb")
    template '001_create_file_blobs.rb.erb',
        File.join('db', 'migrate',
                  "20161029000001_create_#{file_name.tableize}.rb")
    template 'file_blobs.yml.erb',
             File.join('test', 'fixtures', "#{file_name.tableize}.yml")

    copy_file File.join('files', 'invoice.pdf'),
              File.join('test', 'fixtures', 'files', 'invoice.pdf')
    copy_file File.join('files', 'ruby.png'),
              File.join('test', 'fixtures', 'files', 'ruby.png')
  end
end  # class FileBlobs::BlobModelGenerator

end  # namespace FileBlobs
