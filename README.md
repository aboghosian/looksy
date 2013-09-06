# Looksy

Looksy allows you to add a caching layer to any object that responds to the following methods:

* .all - returns a collection of objects
* #id - returns a unique identifier for an object
* #attributes - a hash containing attributes and their values which can be used to filter the collection of objects returned by the .all method.

Loosky was primarily designed to work with ActiveRecord models representing lookup tables in a database.
It works by loading the collection, returned from the .all method, in cache and then filtering those
records based on their attributes. If you think your collection is too big to store in cache then
Looksy is not the right tool.

## Installation

Add this line to your application's Gemfile:

    gem 'looksy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install looksy

## Usage

Looksy was designed to work with ActiveRecord, but can work with any object that responds to .all, #id and #attributes.
Simply include Looksy::Cacheable in the class that you want to cache.

    class Category < ActiveRecord::Base
        include Looksy::Cacheable
    end

### Configuration

The Looksy::Cacheable module provides the following configuration methods:

    class Category < ActiveRecord::Base
        include Looksy::Cacheable
        
        self.cache_store = MyCacheStore.new
        self.cache_key = 'my_cache_store_key'
        self.cache_options = { expires_in: 1.hour }
    end

#### Defaults

The configuration methods above do have defaults and so do not require setting:

* `cache_store` - defaults to Rails cache or an in-memory cache
* `cache_key` - defaults to the `classname/all`
* `cache_options` - defaults to an empty hash

### Methods Added by Looksy::Cacheable

    class Category < ActiveRecord:Base
        include Looksy::Cacheable
        
        # attributes - id, name, parent_id, status
    end
    
Assuming the class above here are the methods you have available to you:

* `Category.fetch_all` - returns the entire collection
* `Category.fetch_first` - returns the first object in the collection
* `Category.fetch_last` - returns the last object in the collection
* `Category.fetch_by_id(id)` - returns the object matching the id
* `Category.fetch_all_by_status(status)` - returns a collection filtered by status
* `Category.fetch_all_by_status_and_parent_id(status, parent_id)` - returns a collection filtered by status and parent id
* `Category.fetch_by_name(name)` - returns the first object matching the name
* `Category.fetch_by_parent_id_and_status(parent_id, status)` - returns the first object matching the parent id and status
* `Category.fetch_last_by_parent_id(parent_id)` - returns the last object matching the parent id
* `Category.fetch_last_by_parent_id_and_status(parent_id, status)` - returns the last object matching the parent id and status

All methods above, after `fetch_by_id`, are dynamic methods that operate based on the attributes hash returned by an instance.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
