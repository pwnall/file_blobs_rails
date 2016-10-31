class GemTestMessage < ActiveRecord::Base
  has_file_blob :attachment, blob_model: 'GemTestBlob', allow_nil: true

  has_file_blob :signature, blob_model: 'GemTestBlob', allow_nil: true
end
