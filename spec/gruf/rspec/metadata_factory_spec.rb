# Copyright (c) 2018-present, BigCommerce Pty. Ltd. All rights reserved
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require 'spec_helper'

RSpec.describe Gruf::Rspec::MetadataFactory do
  let(:options) { {} }
  let(:metadata) { {} }
  let(:factory) { described_class.new(options) }

  describe '.build' do
    subject { factory.build(metadata) }

    context 'when using basic auth' do
      let(:username) { 'foo' }
      let(:password) { 'bar' }
      let(:options) do
        {
          authentication_options: {
            header_key: 'authorization',
            username: username,
            password: password,
          },
          authentication_type: :basic
        }
      end

      it 'should hydrate the auth' do
        expect(subject.key?('authorization')).to be_truthy
        expect(subject['authorization']).to eq "Basic #{Base64.encode64('foo:bar')}"
      end
    end

    context 'when using no auth' do
      it 'should noop' do
        expect(subject).to eq({})
      end
    end
  end
end
