module FileBlobs

class Engine < Rails::Engine
  generators do
    require_relative 'generators/blob_model_generator.rb'
    require_relative 'generators/blob_owner_generator.rb'
  end
end  # class FileBlobs::Engine

end  # namespace FileBlobs
