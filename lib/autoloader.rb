# frozen_string_literal: true

# use Zeitwerk to lazily autoload all the files in the lib directory
require 'zeitwerk'
lib_path = __dir__.to_s
loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.ignore("#{lib_path}/gruf/rspec/railtie.rb")
loader.setup
