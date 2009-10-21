require File.expand_path(File.join(RAILS_ROOT, "spec/javascript/jasmine_helper.rb"))

namespace :test do
  desc "Run continuous integration tests"
  require "spec"
  require 'spec/rake/spectask'

  Spec::Rake::SpecTask.new(:ci) do |t|  
    t.spec_opts = ["--color", "--format", "specdoc"]
    t.spec_files = ["spec/jasmine_spec_runner.rb"]
  end
end

desc "Run specs via server"
task :jasmine_server do
  require File.expand_path(File.join(JasmineHelper.jasmine_root, "contrib/ruby/jasmine_spec_builder"))

  puts "your tests are here:"
  puts "  http://localhost:8888/run.html"

  Jasmine::SimpleServer.start(8888,
                              lambda { JasmineHelper.spec_file_urls },
                              JasmineHelper.dir_mappings)
end
