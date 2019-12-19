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
module Gruf
  module Rspec
    ##
    # Match errors and properly handle validations
    #
    class ErrorMatcher
      attr_writer :serialized_block
      attr_reader :serialized_block_errors

      ##
      # @param [Proc] rpc_call_proc The underlying yielded controller proc to call
      # @param [Class] expected_error_class The expected error class to occur
      # @param [Proc|lambda|Nil] serialized_block If passed, the serialized block for inspecting errors
      #
      def initialize(rpc_call_proc:,
                     expected_error_class:,
                     serialized_block:)
        @rpc_call_proc = rpc_call_proc
        @expected_error_class = expected_error_class
        @serialized_block = serialized_block

        @error_class_matched = false
        @error_serializer = Gruf.error_serializer
        @serialized_block_errors = []
      end

      ##
      # @return [Boolean]
      #
      def valid?
        run_rpc_call
        run_serialized_block
        error_class_matched? && !serialized_block_errors?
      end

      ##
      # @return [String]
      #
      def error_message
        if serialized_block_errors?
          "Failed with serialized error validations: #{@serialized_block_errors.join("\n")}"
        else
          "Response class #{@rpc_response.class} did not match expected error class #{@expected_error_class}"
        end
      end

      private

      ##
      # Did the error class match?
      #
      def error_class_matched?
        @error_class_matched
      end

      ##
      # Were there any downstream errors in the serialized block chain?
      #
      def serialized_block_errors?
        @serialized_block_errors.any?
      end

      ##
      # Was the method chain called with .with_serialized
      #
      # @return [Boolean]
      #
      def serialized_block?
        @serialized_block
      end

      ##
      # Run the actual rpc call
      #
      def run_rpc_call
        @rpc_response = @rpc_call_proc.call
      rescue StandardError => e
        @error_class_matched = e.is_a?(@expected_error_class)
        @rpc_response = e
      end

      ##
      # Run the serialized block, if any, and if the error class matches
      #
      def run_serialized_block
        return unless error_class_matched? && serialized_block?

        @serialized_block.call(deserialize_error)
        true
      rescue ::RSpec::Expectations::ExpectationNotMetError, ::RSpec::Expectations::MultipleExpectationsNotMetError => e
        @serialized_block_errors << e.message
      end

      ##
      # Deserialize the error from the response
      #
      def deserialize_error
        @error_serializer&.new(@rpc_response.to_status.metadata[Gruf.error_metadata_key.to_sym])&.deserialize
      end
    end
  end
end
