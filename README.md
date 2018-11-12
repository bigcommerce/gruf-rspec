# gruf-rspec

RSpec assistance helpers and custom type for easy testing Gruf controllers with RSpec.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gruf-rspec'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gruf-rspec

## Usage

* Add a test for a Gruf controller in `spec/rpc`
* Add two `let` blocks: `grpc_method` and `grpc_message`
* Have your subject be `gruf_response`
* Enjoy!
