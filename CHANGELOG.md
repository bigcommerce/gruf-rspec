Changelog for the gruf-rspec gem.

### Pending release

- Add support for Ruby 3.2
- Drop support for Ruby 2.7 (EOL March 2023)

### 0.6.0

- Add better support for Gruf 2.15+ autoloading in a Rails test environment
- Use zeitwerk for autoloading in this library

### 0.5.0

- Add support for Ruby 3.1
- Drop support for Ruby 2.6

### 0.4.0

- Remove unnecessarily strict dev dependencies
- Adds support for Ruby 3.0 into test suite

### 0.3.0

- [#7] Fix issue where RPC_SPEC_PATH defaulting is hardcoded
- Drop support for Ruby < 2.6, add 2.7 tests
- Update rubocop to 1.0

### 0.2.2

* Loosen rspec dependency

### 0.2.1

* Loosen rack dependency

### 0.2.0

* Deprecate support for Ruby < 2.4

### 0.1.3

* Add ability to include metadata in rpc callsa

### 0.1.2

* Fix issue with RSPEC_NAMESPACE conflicts with other gems

### 0.1.1

* Add be_a_successful_rpc matcher that matches on success and the appropriate response class

### 0.1.0

* Initial release
