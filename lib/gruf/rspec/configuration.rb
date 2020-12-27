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
require_relative 'authentication_hydrators/base'
require_relative 'authentication_hydrators/basic'

module Gruf
  module Rspec
    ##
    # Represents configuration settings for the system
    #
    module Configuration
      DEFAULT_RSPEC_PATH = '/spec/rpc/'
      VALID_CONFIG_KEYS = {
        authentication_hydrators: {
          base: Gruf::Rspec::AuthenticationHydrators::Base,
          basic: Gruf::Rspec::AuthenticationHydrators::Basic
        },
        rpc_spec_path: DEFAULT_RSPEC_PATH
      }.freeze

      attr_accessor *VALID_CONFIG_KEYS.keys

      ##
      # Whenever this is extended into a class, setup the defaults
      #
      def self.extended(base)
        base.reset
      end

      ##
      # Yield self for ruby-style initialization
      #
      # @yields [Gruf::Rspec::Configuration] The configuration object for gruf
      # @return [Gruf::Rspec::Configuration] The configuration object for gruf
      #
      def configure
        yield self
      end

      ##
      # Return the current configuration options as a Hash
      #
      # @return [Hash] The configuration for gruf, represented as a Hash
      #
      def options
        {}.tap do |opts|
          VALID_CONFIG_KEYS.each_key do |k|
            next opts.merge!(k => ENV.fetch('RPC_SPEC_PATH', send(k))) if k == :rpc_spec_path

            opts.merge!(k => send(k))
          end
        end
      end

      ##
      # Set the default configuration onto the extended class
      #
      # @return [Hash] options The reset options hash
      #
      def reset
        VALID_CONFIG_KEYS.each { |k, v| send("#{k}=", v) }
        options
      end
    end
  end
end
