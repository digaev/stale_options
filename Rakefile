require "bundler/gem_tasks"
require "rake/testtask"
require "appraisal"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

if !ENV["APPRAISAL_INITIALIZED"] && !ENV["TRAVIS"]
  task :default do
    sh "appraisal install && rake appraisal test"
  end
else
  task :default => :test
end

