# file_blobs_rails

This is a [Ruby on Rails](http://rubyonrails.org/)
[engine](http://guides.rubyonrails.org/engines.html) that contains the
infrastructure for storing files in the application's database.

The file metadata is inlined in the model that contains the file, so details
like the file's size and type can be displayed in views quickly. The file
contents is stored in a dedicated blobs table, so it is only loaded in the
application's memory when the file is explicitly requested.

The engine implements content deduplication and etag-based caching.


## Integration

Create the model that will host the file contents. The idiomatic name for this
model is `FileBlob`.

```bash
rails g file_blobs:blob_model file_blob
```

Scaffold a model that will contain a file. The default attribute name is
`file`.

```bash
rails g file_blobs:blob_owner message --attr_name attachment
```

An easy way to add file storage functionality to an existing model is to
scaffold a new model, move the generated code into your existing model, and
remove the scaffold.


## Contributing to file_blobs_rails

* Check out the latest master to make sure the feature hasn't been implemented
  or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it
  and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to
  have your own version, or is otherwise necessary, that is fine, but please
  isolate to its own commit so I can cherry-pick around it.


## Copyright

Copyright (c) 2016 Victor Costan, released under the MIT license.
