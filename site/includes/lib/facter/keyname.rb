require 'facter'
#
# This fact determines which classes to include via hiera.
# See "manifests/site.pp" or "git grep -i keyname".
#
# Basic rules: Read the "KEYNAME" environment variable.
# If the variable is unset, default to "a_key".
# If the variable is set to a known (valid) value, use that value.
# If the variable is set to an unrecognized value, abort.
#
module Foo
  Foo::DEFAULT_KEYNAME = 'classes'.freeze unless defined?(Foo::DEFAULT_KEYNAME)

  # If the "KEYNAME" environment variable is set,
  # it must have one of these values. This avoids accidents.
  unless defined?(Foo::VALID_KEYNAMES)
    VALID_KEYNAMES = %W[
      #{Foo::DEFAULT_KEYNAME}
      other_classes
    ].map(&:downcase).freeze
  end

  # Custom error type to indicate a value not in VALID_KEYNAMES.
  class InvalidKeyname < StandardError
  end

  # Contain the logic for the "keyname" fact.
  # Putting the code in a ruby class makes it easier to write rspec.
  class Keyname
    # Check the "PUPPET_LAYER" environment variable for a valid value.
    #
    # @return [STRING] the name of the key to use in hieradb
    def self.value
      val = (ENV['KEYNAME'] || Foo::DEFAULT_KEYNAME).downcase
      raise Foo::InvalidKeyname unless Foo::Keyname.valid?(val)
      val
    rescue Foo::InvalidKeyname
      # site.pp interprets "unrecognized" as a failure condition and
      # generates a puppet parse error with an informative hint.
      'unrecognized'
    end

    # Test whether a value is a valid keyname.
    #
    # @return [BOOL] whether or not the input is a valid keyname
    def self.valid?(a_str)
      Foo::VALID_KEYNAMES.include?(a_str)
    end
  end
end

Facter.add(:keyname) do
  # DO NOT CONFINE
  setcode { Foo::Keyname.value }
end
