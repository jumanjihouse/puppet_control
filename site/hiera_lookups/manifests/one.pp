class hiera_lookups::one() {
  # If this key does not exist in hiera,
  # puppet raises Puppet::DataBinding::LookupError
  # since we don't provide a default value.
  $lookup_1 = lookup('lookup_1', String)

  if empty("${lookup_1}") {
    # This code never gets executed because
    # the catalog compile fails if the lookup fails.
    # Puppet raises
    fail("lookup_1 was not found in hiera.")
  }

  user { user1:
    ensure   => present,
    password => "${lookup_1}",
  }
}
