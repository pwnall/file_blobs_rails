def setup_file_blobs_routes
  # The routes used in all the tests.
  routes = ActionDispatch::Routing::RouteSet.new
  routes.draw do
    get '/file_blob_gem_test/:id' => 'file_blob_gem_test#show'
    post '/file_blob_gem_test' => 'file_blob_gem_test#create'
  end

  # NOTE: ActionController tests expect @routes to be set to the drawn routes.
  #       We use the block form of define_method to capture the routes local
  #       variable.
  ActionController::TestCase.send :define_method, :setup_file_blobs_routes do
    @routes = routes
  end
  ActionController::TestCase.setup :setup_file_blobs_routes
end

setup_file_blobs_routes
