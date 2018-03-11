class hiera_lookups::two() {
  $lookup_2 = lookup('lookup_2', String, 'first', '')

  if empty("${lookup_2}") {
    # This code is valid because we provide
    # a default value for the hiera lookup.
    fail("lookup_2 was not found in hiera.")
  }

  user { user2:
    ensure   => present,
    password => "${lookup_2}",
  }
}
