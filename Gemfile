source 'https://rubygems.org'

################################################################################
# For now limit Puppet <= 5.3.3
#
# See https://github.com/dylanratcliffe/onceover/issues/153
# for simplist explanation.
#
# See also: https://tickets.puppetlabs.com/browse/MODULES-6598
################################################################################

# Core gems for the test harness.
gem 'json', '2.1.0'
gem 'metadata-json-lint', '2.1.0'
gem 'puppet', ENV['PUPPET_VERSION'] || '5.3.3'
gem 'puppetlabs_spec_helper', '2.6.2'
gem 'r10k', '2.6.2'
gem 'rubocop', '0.53.0'

if RUBY_VERSION >= '2.3.0'
  gem 'rubocop-rspec', '1.24.0'
end

if RUBY_VERSION >= '2.5.0'
  # These gems used to be part of ruby.
  gem 'bigdecimal'
end
