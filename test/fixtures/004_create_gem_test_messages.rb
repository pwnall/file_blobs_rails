class CreateGemTestMessages < ActiveRecord::Migration[5.0]
  def change
    create_file_blobs_table :gem_test_messages, blob_limit: 64.kilobytes do |t|
      # Test the options.
      t.file_blob :attachment, null: true, mime_type_limit: 16,
          original_name_limit: 64

      t.file_blob :signature, null: true

      # Test that the block is invoked with the correct argument.
      t.string :subject, null: false, limit: 64
      t.timestamps
    end
  end
end
