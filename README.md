# gruf-rspec

[![Build Status](https://travis-ci.com/bigcommerce/gruf-rspec.svg?token=D3Cc4LCF9BgpUx4dpPpv&branch=master)](https://travis-ci.com/bigcommerce/gruf-rspec)

Assistance helpers and custom type for easy testing [Gruf](https://github.com/bigcommerce/gruf) controllers with 
[RSpec](https://github.com/rspec/rspec).

## Installation

```ruby
gem 'gruf-rspec'
```
    
Then add the following code to your `spec_helper.rb`:

```ruby
require 'gruf/rspec'
``` 

Note that this gem requires at least Gruf 2.5.1+ and RSpec 3.8+.

## Usage

* Add a test for a Gruf controller in `spec/rpc`
* Run the `run_rpc` method with two args: The gRPC method name, and the request object
* Validate the response

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
    let(:request_proto) { Rpc::GetThingResponse.new(id: rand(1..100)) }
    
    subject { run_rpc(:GetThing, request_proto) }
    
    it 'will return the thing' do
      expect(subject).to be_a(Rpc::GetThingResponse)
      expect(subject.id).to eq request_proto.id
    end
  end
end
```

Alternatively, you can pass a block:

```ruby
it 'will return the thing' do
  run_rpc(:GetThing, request_proto) do |resp|
    expect(resp).to be_a(Rpc::GetThingResponse)
    expect(resp.id).to eq request_proto.id
  end
end
```

### Accessing the Bound Service

Note that you can also access the bound gRPC service class:

```ruby
it 'binds the service correctly' do
  expect(grpc_bound_service).to eq Rpc::Things::Service
end
``` 

### Matching Errors

You can match against errors as well:

```ruby
describe 'testing an error' do
  let(:request_proto) { Rpc::GetThingResponse.new(id: rand(1..100)) }
  
  subject { run_rpc(:GetThing, request_proto) }
  
  it 'should fail with the appropriate error' do
    expect { subject }.to raise_rpc_error(GRPC::InvalidArgument)
  end
end
```

Or further, even check your serialized error that is passed in metadata:

```ruby
it 'should fail with the appropriate error code' do
  expect { subject }.to raise_rpc_error(GRPC::InvalidArgument).with_serialized { |err|
    expect(err).to be_a(MyCustomErrorClass)
    expect(err.error_code).to eq 'invalid_request'
  
    fe = err.field_errors.first
    expect(fe.field_name).to eq 'name'
    expect(fe.error_code).to eq 'invalid_name'
    expect(fe.error_message).to eq 
  }
end
```

Note that when using `with_serialized`, you _must_ pass the block with `{ }`, not using
`do` and `end`.


### RSpec Controller Matcher Configuration

By default, the type matcher for Gruf controllers matches in `/spec/rpc`. You can customize this by configuring it
in the `Gruf::Rspec` confiugration block like so:

```ruby
Gruf::Rspec.configure do |c|
  c.rpc_spec_path = '/spec/rpc_controllers'
end
```

## License

Copyright (c) 2018-present, BigCommerce Pty. Ltd. All rights reserved

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
