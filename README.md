# Puppet Control

This is a demo Puppet Control repo with a test harness.

## How to

### Run the test harness

On a Linux host with a modern version of Ruby:

    ci/test

Output should resemble:

    hiera_lookups::one
      with actual hiera lookup
        should contain User[user1] with password =~ /.+/
      with fake hiera lookup
        should contain User[user1] with password => "fake_password_string"
      when lookup() does not specify a default value
        when hieradb is missing
          should not compile into a catalogue without dependency cycles
          should raise Puppet::DataBinding::LookupError
        when key is not in hiera
          should not compile into a catalogue without dependency cycles
          should raise Puppet::DataBinding::LookupError

    hiera_lookups::two
      with actual hiera lookup
        should contain User[user2] with password =~ /.+/
      with fake hiera lookup
        should contain User[user2] with password => "another_fake_password_string"
      when lookup() specifies a default value
        when hieradb is missing
          should not compile into a catalogue without dependency cycles
          should raise Puppet::PreformattedError
        when key is not in hiera but specifies a default value
          should not compile into a catalogue without dependency cycles
          should raise Puppet::PreformattedError

    hiera_lookups
      should compile into a catalogue without dependency cycles
      should contain Class[hiera_lookups::one]
      should contain Class[hiera_lookups::two]
