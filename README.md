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

## Example

In `spec/rpc/thing_controller_spec.rb`:

```ruby
describe ThingController do
  subject { gruf_response }

  describe '.get_thing' do
    let(:id) { rand(0..100) }
    let(:grpc_method) { :GetThing }
    let(:grpc_message) { Rpc::GetThingResp.new(id: id) }
    
    it 'return the thing' do
      expect(subject).to be_a(Rpc::GetThingResp)
      expect(subject.id).to eq id
    end
  end
end
```
