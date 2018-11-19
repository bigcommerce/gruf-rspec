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
* Run the `run_rpc` method with two args: The gRPC method name, and the request object
* Pass a block that you will get the response in
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
    let(:request_proto) { Rpc::GetThingResponse.new(id: rand(1..100)) }
    
    it 'will return the thing' do
      run_rpc(:GetThing, request_proto) do |resp|
        expect(resp).to be_a(Rpc::GetThingResponse)
        expect(resp.id).to eq request_proto.id
      end
    end
  end
end
```

Alternatively, you can not pass a block and just get the return value:

```ruby
it 'will return the thing' do
  resp = run_rpc(:GetThing, request_proto)
  expect(resp).to be_a(Rpc::GetThingResponse)
  expect(resp.id).to eq request_proto.id
end
```

### Matching Errors

You can match against errors as well:

```ruby
let(:request_proto) { Rpc::GetThingResponse.new(id: rand(1..100)) }

it 'should fail with the appropriate error' do
  expect { run_rpc(:GetThing, request_proto) }.to raise_rpc_error(GRPC::InvalidArgument)
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
