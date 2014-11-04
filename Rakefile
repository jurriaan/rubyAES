require 'bundler/gem_tasks'
require 'rubocop'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/docparser'
  t.test_files = FileList['test/lib/**/*_test.rb']
  t.verbose = true
end

# task test: :rubocop

task :rubocop do
  puts "Running Rubocop #{RuboCop::Version::STRING}"
  args = FileList['**/*.rb', 'Rakefile', 'ruby-aes.gemspec', 'Gemfile']
  cli = RuboCop::CLI.new
  fail unless cli.run(args) == 0
end

task default: :test
