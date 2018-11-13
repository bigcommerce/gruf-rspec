# gruf-rspec

[![Build Status](https://travis-ci.com/bigcommerce/gruf-rspec.svg?token=D3Cc4LCF9BgpUx4dpPpv&branch=master)](https://travis-ci.com/bigcommerce/gruf-rspec)

RSpec assistance helpers and custom type for easy testing Gruf controllers with RSpec.

## Installation

```ruby
gem 'gruf-rspec'
```
    
Then add the following code to your `spec_helper.rb`:

```ruby
require 'gruf/rspec'
``` 

## Usage

* Add a test for a Gruf controller in `spec/rpc`
* Add two `let` blocks: `method_name` and `request`
* Have your subject be `response`
* Enjoy!

## Example

Let's assume you have a gruf controller named `ThingController` that is bound to the gRPC 
service `Rpc::Things::Service`. That has a method `GetThing`:

```ruby
class ThingController < Gruf::Controllers::Base
  bind ::Rpc::Things::Service
  
  def get_thing
    Rpc::GetThingResponse.new(id: request.message.id)
  end
end
```

To test it, you'd create `spec/rpc/thing_controller_spec.rb`:

```ruby
describe ThingController do
  describe '.get_thing' do
    let(:method_name) { :GetThing }
    let(:request) { Rpc::GetThingResp.new(id: rand(1..100)) }
    
    it 'return the thing' do
      expect(response).to be_a(Rpc::GetThingResponse)
      expect(response.id).to eq request.id
    end
  end
end
```
