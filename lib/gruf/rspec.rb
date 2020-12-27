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
begin
  require 'rspec/core'
  require 'rspec/expectations'
  GRUF_RSPEC_NAMESPACE = RSpec
  GRUF_RSPEC_RUNNER = RSpec
rescue LoadError # old rspec compat
  require 'spec'
  GRUF_RSPEC_NAMESPACE = Spec
  GRUF_RSPEC_RUNNER = Spec::Runner
end

require_relative 'rspec/version'
require_relative 'rspec/configuration'
require_relative 'rspec/helpers'
require_relative 'rspec/error_matcher'

##
# Base gruf module
#
module Gruf
  ##
  # Base gruf-rspec module
  #
  module Rspec
    extend Gruf::Rspec::Configuration
  end
end

Gruf::Rspec.reset # initial reset

GRUF_RSPEC_RUNNER.configure do |config|
  config.include Gruf::Rspec::Helpers

  config.define_derived_metadata(file_path: Regexp.new(Gruf::Rspec.rpc_spec_path)) do |metadata|
    metadata[:type] = :gruf_controller
  end

  config.before(:each, type: :gruf_controller) do
    define_singleton_method :run_rpc do |method_name, request, active_call_options: {}, &block|
      @gruf_controller = described_class.new(
        method_key: method_name.to_s.underscore.to_sym,
        service: grpc_bound_service,
        rpc_desc: grpc_bound_service.rpc_descs[method_name.to_sym],
        active_call: grpc_active_call(active_call_options),
        message: request
      )
      resp = @gruf_controller.call(@gruf_controller.request.method_key)
      block.call(resp) if block.is_a?(Proc)
      resp
    end

    define_singleton_method :grpc_bound_service do
      described_class.bound_service
    end

    define_singleton_method :gruf_controller do
      @gruf_controller
    end
  end
end

GRUF_RSPEC_NAMESPACE::Matchers.define :raise_rpc_error do |expected_error_class|
  supports_block_expectations

  def with_serialized(&block)
    @serialized_block = block
    self
  end

  match do |rpc_call_proc|
    @error_matcher = Gruf::Rspec::ErrorMatcher.new(
      rpc_call_proc: rpc_call_proc,
      expected_error_class: expected_error_class,
      serialized_block: @serialized_block
    )
    @error_matcher.valid?
  end

  failure_message do |_|
    @error_matcher.error_message
  end
end

GRUF_RSPEC_NAMESPACE::Matchers.define :be_a_successful_rpc do |_|
  match do |actual|
    if !gruf_controller || actual.is_a?(GRPC::BadStatus) || actual.is_a?(GRPC::Core::CallError)
      false
    else
      method_key = gruf_controller.request.method_key.to_s.camelcase.to_sym
      expected_class = gruf_controller.class.bound_service.rpc_descs[method_key].output
      expected_class == actual.class
    end
  end
end
