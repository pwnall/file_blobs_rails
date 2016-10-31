require_relative 'test_helper'

class FileBlobGemTestController < ActionController::Base
  before_action :set_blob_owner, only: [:show]

  # POST /file_blob_gem_test
  def create
    blob_owner = BlobOwner.create! blob_owner_params
    render json: blob_owner
  end

  # GET /file_blob_gem_test
  def show
    send_file_blob @blob_owner.file
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_blob_owner
    @blob_owner = BlobOwner.find params[:id]
  end
  private :set_blob_owner

  # Only allow a trusted parameter "white list" through.
  def blob_owner_params
    params.require(:blob_owner).permit(:file)
  end
  private :blob_owner_params
end

class ControllerExtensionsTest < ActionController::TestCase
  tests FileBlobGemTestController

  # Workaround the issue that is well-documented but incorrectly addressed in
  # https://github.com/rails/rails/pull/25796
  # include ActionDispatch::TestProcess

  test 'can read files from ActionDispatch::Http::UploadedFile' do
    BlobOwner.destroy_all
    FileBlob.destroy_all

    post :create, params: { blob_owner: {
        file: fixture_file_upload('files/ruby.png', 'image/png', :binary) } }

    assert_response :success

    assert_equal 1, BlobOwner.count

    blob_owner = BlobOwner.last
    assert_equal 'image/png', blob_owner.file.mime_type
    assert_equal 'ruby.png', blob_owner.file.original_name
    assert_equal file_blob_size('files/ruby.png'), blob_owner.file.size
    assert_equal file_blob_data('files/ruby.png'), blob_owner.file.data
  end

  test '#send_file_blob generates a fresh response correctly' do
    get :show, params: { id: blob_owners(:ruby).id }

    assert_response :success
    assert_equal 'image/png', response.headers['Content-Type']
    assert_equal file_blob_id('files/ruby.png'), response.headers['ETag']
    assert_equal file_blob_data('files/ruby.png'), response.body
  end

  test '#send_file_blob sends 200 for requests with non-matching e-tags' do
    request.set_header 'HTTP_IF_NONE_MATCH', '1234'
    get :show, params: { id: blob_owners(:ruby).id }

    assert_response :success
    assert_equal 'image/png', response.headers['Content-Type']
    assert_equal file_blob_id('files/ruby.png'), response.headers['ETag']
    assert_equal file_blob_data('files/ruby.png'), response.body
  end

  test '#send_file_blob sends 304 for requests with matching e-tags' do
    request.set_header 'HTTP_IF_NONE_MATCH', file_blob_id('files/ruby.png')
    get :show, params: { id: blob_owners(:ruby).id }

    assert_response :not_modified
  end
end
