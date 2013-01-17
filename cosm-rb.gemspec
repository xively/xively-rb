# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cosm-rb/version"

Gem::Specification.new do |s|
  s.name        = "cosm-rb"
  s.version     = Cosm::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paul Bellamy", "Levent Ali", "Sam Mulube"]
  s.email       = ["paul.a.bellamy@gmail.com", "lebreeze@gmail.com", "sam@pachube.com"]
  s.homepage    = "http://github.com/cosm/cosm-rb"
  s.summary     = "A library for communicating with the Cosm REST API, parsing and rendering Cosm feed formats"
  s.description = "A library for communicating with the Cosm REST API, parsing and rendering Cosm feed formats"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("multi_json", ">=1.3.6")
  s.add_dependency("multi_xml", ">=0.5.2")
  s.add_dependency("yajl-ruby", ">=1.1.0")
  s.add_dependency("nokogiri", ">=1.5.6")
  s.add_dependency("httparty", ">=0.10.0")

  if RUBY_VERSION.to_f < 1.9
    s.add_dependency("fastercsv", ">=1.5.x")
  end

  begin
    if !defined?(JRUBY_VERSION)
      s.add_dependency("ox", ">= 1.5.9")
      if RUBY_VERSION.to_f < 1.9
        s.add_development_dependency("ruby-debug")
        s.add_development_dependency("rcov", ">=0.9.9")
      else
        s.add_development_dependency("simplecov", ">=0.7.1")
      end
    end
  rescue
    p "Could not detect ruby version"
  end
  s.add_development_dependency("rake", "=0.8.7")
  s.add_development_dependency("rspec", "=2.6.0")

  s.extra_rdoc_files = ["README.md", "CHANGELOG.md", "MIT-LICENSE"]
  s.rdoc_options << '--main' << 'README'
end

