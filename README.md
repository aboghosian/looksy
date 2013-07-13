# Looksy

Looksy adds a caching layer for your ActiveRecord models
that represent look up tables in your database.

## Installation

Add this line to your application's Gemfile:

    gem 'looksy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install looksy

## Usage

Include Looksy::Cacheable in your ActiveRecord class.
Provides fetch_all and fetch_by_id(id) methods as well
as intercepts method_missing so you can use dynamic methods
such as fetch_by_name('name') or fetch_all_by_status('active').
You can also fetch by multiple columns such as:
fetch_by_type_and_status('type', 'status').

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
