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

describe Gruf::Rspec::ErrorMatcher do
  let(:rpc_call_proc) { proc { true } }
  let(:expected_error_class) { GRPC::NotFound }
  let(:serialized_block) { nil }

  let(:error_matcher) do
    described_class.new(
      rpc_call_proc: rpc_call_proc,
      expected_error_class: expected_error_class,
      serialized_block: serialized_block
    )
  end

  describe '#valid?' do
    subject { error_matcher.valid? }

    context 'when the error class matches' do
      let(:rpc_call_proc) { proc { raise expected_error_class } }

      it 'is valid' do
        expect(subject).to be_truthy
      end

      context 'when there failed expectations in the serialized block' do
        let(:serialized_block) do
          proc { expect(true).to be_falsey }
        end

        it 'is not valid' do
          expect(subject).to be_falsey
        end
      end

      context 'when there are all passing expectations in the serialized block' do
        let(:serialized_block) do
          proc { expect(true).to be_truthy }
        end

        it 'is valid' do
          expect(subject).to be_truthy
        end
      end
    end

    context 'when the error class does not match' do
      let(:rpc_call_proc) { proc { raise GRPC::InvalidArgument } }

      it 'is not valid' do
        expect(subject).to be_falsey
      end
    end

    context 'when no error is thrown' do
      let(:rpc_call_proc) { proc { true } }

      it 'is not valid' do
        expect(subject).to be_falsey
      end
    end
  end
end
