class GemTestBlob < ActiveRecord::Base
  include FileBlobs::BlobModel

  blob_owner_class_names! 'GemTestMessage'
end
