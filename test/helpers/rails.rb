# Mock Rails.root.
module Rails
  class <<self
    remove_method :root if Rails.respond_to? :root
    def root
      Pathname.new File.expand_path('../..', File.dirname(__FILE__))
    end
  end
end
