# Epiphany
Open Source Ruby on Rails engine to build Custom Voice Assistants

## Usage
*Currently in Alpha 

## Installation
The configs for each model are stored in a traditional relational database. For now we are using postgres in our examples.
Add this line to your Rails application's Gemfile:

```ruby
gem 'pg'
gem 'epiphany', :git => "git://github.com:geekdreamzz/epiphany.git", :branch => "alpha"
```

And then execute:
```bash
$ bundle
```

Mount the Engine in routes.rb, example:
```ruby
mount Epiphany::Engine => "/epiphany"
```

You can add custom authorization logic. Let's say you had an application helper method in your app named :quick_auth which you'd like to use to enforce authentication. You can configure the Epiphany library to reference that when using the epiphany admin web interface. Add something like this in a file in the initializers directory:
```ruby
Epiphany::Config.set do |config|
  config.auth = :quick_auth
end
```

## Contributing
Send Me a Message or submit a PR :) 

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
