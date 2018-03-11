require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet-lint/tasks/puppet-lint'

if RUBY_VERSION >= '2.3.0'
  RuboCop::RakeTask.new { |task| task.requires << 'rubocop-rspec' }
end

task :default do
  Rake::Task[:help].invoke
end
