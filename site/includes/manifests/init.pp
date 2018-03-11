class includes() {
  if $facts['keyname'] == 'unrecognized' {
    fail('Env variable "KEYNAME" is set to an unrecognized value.')
  }
  else {
    lookup($facts['keyname'], Array[String], 'unique', []).include
  }
}
