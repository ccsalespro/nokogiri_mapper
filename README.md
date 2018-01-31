# NokogiriMapper

NokogiriMapper is a DSL for building structs that map to and from XML using [Nokogiri](https://github.com/sparklemotion/nokogiri).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nokogiri_mapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nokogiri_mapper

## Usage

Subclass `NokogiriMapper::Struct` and declare fields.

```ruby
class User < NokogiriMapper::Struct
  string :name
  bool :active
end
```

Call `to_xml` to produce and XML string.

```ruby
User.new(name: "joe", active: true).to_xml
```

Call `from_xml` to parse XML into an object.

```ruby
User.from_xml("<user><name>joe</name><active>1</active></user>")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ccsalespro/nokogiri_mapper.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
