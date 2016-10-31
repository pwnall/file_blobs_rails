class CreateGemTestBlobs < ActiveRecord::Migration[5.0]
  def change
    create_file_blobs_table :gem_test_blobs, blob_limit: 64.kilobytes do |t|
      # Test that the block is invoked with the correct argument.
      t.timestamps
    end
  end
end
