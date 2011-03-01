# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pachube_data_formats/version"

Gem::Specification.new do |s|
  s.name        = "pachube_data_formats"
  s.version     = PachubeDataFormats::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paul Bellamy", "Levent Ali"]
  s.email       = ["paul.a.bellamy@gmail.com", "lebreeze@gmail.com"]
  s.homepage    = "http://github.com/pachube/pachube_data_formats"
  s.summary     = %q{pachube_data_formats is a gem designed to make interfacing with pachube easier. It converts to and from Pachube's data formats.}
  s.description = <<-EOF
pachube_data_formats is a gem designed to make interfacing with pachube easier. It converts to and from Pachube's data formats.
  EOF

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_rubygems_version = ">=1.3.6"

  s.add_dependency("yajl-ruby", ">=0.8.1")
  s.add_dependency("nokogiri", ">=1.4.4")

  s.add_development_dependency("rake", ">=0.8.7")
  s.add_development_dependency("rspec", "=2.5.0")
  s.add_development_dependency("ruby-debug")
  s.add_development_dependency("rcov", ">=0.9.9")
  s.add_development_dependency("activerecord", "~>2.3.8")
  s.add_development_dependency("sqlite3-ruby", "~>1.3.3")

  s.extra_rdoc_files = ["README.markdown", "CHANGELOG", "MIT-LICENSE"]
  s.rdoc_options << '--main' << 'README'
end

