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
require_relative 'lib/gruf/rspec/version'

Gem::Specification.new do |spec|
  spec.name          = 'gruf-rspec'
  spec.version       = Gruf::Rspec::VERSION
  spec.authors       = ['Shaun McCormick']
  spec.email         = ['splittingred@gmail.com']
  spec.license       = 'MIT'

  spec.summary       = 'RSpec assistance library for gruf'
  spec.description   = 'RSpec assistance library for gruf, including testing helpers'
  spec.homepage      = 'https://github.com/bigcommerce/gruf-rspec'

  spec.required_ruby_version = '>= 3.2', '< 4'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files         = Dir['README.md', 'CHANGELOG.md', 'CODE_OF_CONDUCT.md', 'lib/**/*', 'gruf-rspec.gemspec']
  spec.require_paths = %w[lib]

  spec.add_dependency 'gruf', '~> 2.5', '>= 2.5.1'
  spec.add_dependency 'rake', '>= 12.3'
  spec.add_dependency 'rspec-core', '>= 3.8'
  spec.add_dependency 'rspec-expectations', '>= 3.8'
  spec.add_dependency 'zeitwerk', '>= 2'
end
