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
require_relative 'rspec/version'
require_relative 'rspec/helpers'

module Gruf
  ##
  # Base module
  #
  module Rspec
  end
end

if defined?(RSpec)
  RSpec.configure do |config|
    config.define_derived_metadata(file_path: Regexp.new('/spec/rpc/')) do |metadata|
      metadata[:type] = :gruf_controller
    end

    config.before(:each, type: :gruf_controller) do
      if respond_to?(:grpc_method) && respond_to?(:grpc_message)
        define_singleton_method :grpc_service do
          described_class.bound_service
        end

        define_singleton_method :gruf_method do
          @gruf_method ||= grpc_method.to_s.underscore.to_sym
        end

        define_singleton_method :gruf_controller do
          @gruf_controller ||= described_class.new(
            method_key: gruf_method,
            service: grpc_service,
            rpc_desc: grpc_service.rpc_descs[grpc_method.to_sym],
            active_call: grpc_active_call,
            message: grpc_message
          )
        end

        define_singleton_method :gruf_response do
          @gruf_response ||= gruf_controller.call(gruf_method)
        end
      end
    end

    config.include Gruf::Rspec::Helpers
  end
end
