require 'bundler'
require 'rake/rdoctask'

Bundler::GemHelper.install_tasks
Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end
