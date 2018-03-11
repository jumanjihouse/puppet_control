require 'puppetlabs_spec_helper/module_spec_helper'

repo_root = File.expand_path(File.join(__FILE__, '..', '..'))

# Help Ruby locate all the custom facter facts in this repo.
Dir.glob("#{repo_root}/**/lib/facter").each do |path|
  path = File.expand_path(path)
  next if $LOAD_PATH.include?(path)

  # "require" needs the full path to the directory.
  $LOAD_PATH.unshift(path)

  # Facter appends "facter" to the path, so
  # provide just the "lib" dir (i.e., strip "facter" off the path).
  $LOAD_PATH.unshift(File.split(path)[0])
end

RSpec.configure do |c|
  c.fail_fast = false
  c.setup_fixtures = false

  c.module_path = [
    File.join(repo_root, 'site'),
    File.join(repo_root, 'modules'),
  ].join(':')

  c.manifest_dir = File.join(repo_root, 'manifests')
  c.manifest = File.join(repo_root, 'site.pp')
  c.hiera_config = File.join(repo_root, 'hiera.yaml')

  c.before do
    # Store environment variables (to be restored later)
    @env = {}
    ENV.each { |k, v| @env[k] = v }

    Facter::Util::Loader.stubs(:load_all)
    Facter.clear
    Facter.clear_messages

    RSpec::Mocks.setup
  end

  c.after do
    # Restore environment variables
    @env.each { |k, v| ENV[k] = v }

    # remove environment vars that did not exist before test
    ENV.keys.reject { |k| @env.include?(k) }.each { |k| ENV.delete(k) }

    RSpec::Mocks.verify
    RSpec::Mocks.teardown
  end
end
