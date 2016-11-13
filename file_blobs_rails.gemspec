# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: file_blobs_rails 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "file_blobs_rails"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Victor Costan"]
  s.date = "2016-11-13"
  s.description = "This gem is a quick way to add database-backed file storage to a Rails application. Files are stored in a dedicated table and de-duplicated."
  s.email = "victor@costan.us"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "Gemfile.rails5",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "file_blobs_rails.gemspec",
    "lib/file_blobs_rails.rb",
    "lib/file_blobs_rails/action_controller_data_streaming_extensions.rb",
    "lib/file_blobs_rails/active_record_extensions.rb",
    "lib/file_blobs_rails/active_record_fixture_set_extensions.rb",
    "lib/file_blobs_rails/active_record_migration_extensions.rb",
    "lib/file_blobs_rails/active_record_table_definition_extensions.rb",
    "lib/file_blobs_rails/active_support_test_extensions.rb",
    "lib/file_blobs_rails/blob_model.rb",
    "lib/file_blobs_rails/engine.rb",
    "lib/file_blobs_rails/file_blob_proxy.rb",
    "lib/file_blobs_rails/generators/blob_model_generator.rb",
    "lib/file_blobs_rails/generators/blob_owner_generator.rb",
    "lib/file_blobs_rails/generators/templates/001_create_file_blobs.rb.erb",
    "lib/file_blobs_rails/generators/templates/002_create_blob_owners.rb.erb",
    "lib/file_blobs_rails/generators/templates/blob_owner.rb.erb",
    "lib/file_blobs_rails/generators/templates/blob_owner_test.rb.erb",
    "lib/file_blobs_rails/generators/templates/blob_owners.yml.erb",
    "lib/file_blobs_rails/generators/templates/file_blob.rb.erb",
    "lib/file_blobs_rails/generators/templates/file_blob_test.rb.erb",
    "lib/file_blobs_rails/generators/templates/file_blobs.yml.erb",
    "lib/file_blobs_rails/generators/templates/files/invoice.pdf",
    "lib/file_blobs_rails/generators/templates/files/ruby.png",
    "test/blob_model_test.rb",
    "test/blob_owner_test.rb",
    "test/controller_extensions_test.rb",
    "test/file_blob_proxy_test.rb",
    "test/file_blob_test.rb",
    "test/file_blobs_fixture_test.rb",
    "test/fixtures/003_create_gem_test_blobs.rb",
    "test/fixtures/004_create_gem_test_messages.rb",
    "test/fixtures/files/invoice.pdf",
    "test/fixtures/files/ruby.png",
    "test/fixtures/gem_test_blob.rb",
    "test/fixtures/gem_test_message.rb",
    "test/garbage_collection_test.rb",
    "test/helpers/action_controller.rb",
    "test/helpers/db_setup.rb",
    "test/helpers/fixtures.rb",
    "test/helpers/i18n.rb",
    "test/helpers/migrations.rb",
    "test/helpers/rails.rb",
    "test/helpers/routes.rb",
    "test/helpers/test_order.rb",
    "test/test_extensions_test.rb",
    "test/test_helper.rb"
  ]
  s.homepage = "https://github.com/pwnall/file_blobs_rails"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Database-backed file storage for Rails 5 applications."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 5.0.0.1"])
      s.add_development_dependency(%q<bundler>, [">= 1.6.6"])
      s.add_development_dependency(%q<jeweler>, [">= 2.1.1"])
      s.add_development_dependency(%q<mocha>, [">= 1.2.1"])
      s.add_development_dependency(%q<mysql2>, [">= 0.4.4"])
      s.add_development_dependency(%q<omniauth>, [">= 1.3.1"])
      s.add_development_dependency(%q<pg>, [">= 0.19.0"])
      s.add_development_dependency(%q<rake>, [">= 11.3.0"])
      s.add_development_dependency(%q<sqlite3>, [">= 1.3.12"])
      s.add_development_dependency(%q<yard>, [">= 0.9.5"])
      s.add_development_dependency(%q<rubysl>, [">= 0"])
      s.add_development_dependency(%q<rubysl-bundler>, [">= 0"])
      s.add_development_dependency(%q<rubysl-rake>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 5.0.0.1"])
      s.add_dependency(%q<bundler>, [">= 1.6.6"])
      s.add_dependency(%q<jeweler>, [">= 2.1.1"])
      s.add_dependency(%q<mocha>, [">= 1.2.1"])
      s.add_dependency(%q<mysql2>, [">= 0.4.4"])
      s.add_dependency(%q<omniauth>, [">= 1.3.1"])
      s.add_dependency(%q<pg>, [">= 0.19.0"])
      s.add_dependency(%q<rake>, [">= 11.3.0"])
      s.add_dependency(%q<sqlite3>, [">= 1.3.12"])
      s.add_dependency(%q<yard>, [">= 0.9.5"])
      s.add_dependency(%q<rubysl>, [">= 0"])
      s.add_dependency(%q<rubysl-bundler>, [">= 0"])
      s.add_dependency(%q<rubysl-rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 5.0.0.1"])
    s.add_dependency(%q<bundler>, [">= 1.6.6"])
    s.add_dependency(%q<jeweler>, [">= 2.1.1"])
    s.add_dependency(%q<mocha>, [">= 1.2.1"])
    s.add_dependency(%q<mysql2>, [">= 0.4.4"])
    s.add_dependency(%q<omniauth>, [">= 1.3.1"])
    s.add_dependency(%q<pg>, [">= 0.19.0"])
    s.add_dependency(%q<rake>, [">= 11.3.0"])
    s.add_dependency(%q<sqlite3>, [">= 1.3.12"])
    s.add_dependency(%q<yard>, [">= 0.9.5"])
    s.add_dependency(%q<rubysl>, [">= 0"])
    s.add_dependency(%q<rubysl-bundler>, [">= 0"])
    s.add_dependency(%q<rubysl-rake>, [">= 0"])
  end
end

