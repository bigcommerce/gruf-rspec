# frozen_string_literal: true

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

class TestConfiguration
  include Gruf::Rspec::Configuration
end

RSpec.describe Gruf::Rspec::Configuration do
  let(:obj) { TestConfiguration.new }
  let(:default_path) { '/spec/rpc/' }
  let(:custom_path) { '/spec/gruf/' }

  describe '.reset' do
    subject(:path) { obj.rpc_spec_path }

    before do
      obj.configure { |c| c.rpc_spec_path = custom_path }
      obj.reset
    end

    it 'should reset config vars to default' do
      expect(path).to eq default_path
    end
  end

  describe '.options' do
    subject(:options) { obj.options }

    before { obj.reset }

    it 'should return the options hash with any configured values' do
      obj.configure { |c| c.rpc_spec_path = custom_path }

      expect(options).to be_a(Hash)
      expect(options[:rpc_spec_path]).to eq custom_path
    end

    context 'when RPC_SPEC_PATH is set' do
      before { ENV["RPC_SPEC_PATH"] = custom_path }
      after { ENV["RPC_SPEC_PATH"] = nil }

      it "returns the path from the environment variable" do
        expect(options[:rpc_spec_path]).to eq custom_path
      end
    end

    context 'when RPC_SPEC_PATH is not set' do
      it "returns the default path" do
        expect(options[:rpc_spec_path]).to eq default_path
      end
    end
  end
end
