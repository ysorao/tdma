# -*- encoding: utf-8 -*-
# stub: ruby-hl7 1.2.3 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-hl7".freeze
  s.version = "1.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mark Guzman".freeze]
  s.date = "2018-04-18"
  s.description = "A simple library to parse and generate HL7 2.x messages".freeze
  s.email = "ruby-hl7@googlegroups.com".freeze
  s.extra_rdoc_files = ["README.rdoc".freeze, "LICENSE".freeze]
  s.files = ["LICENSE".freeze, "README.rdoc".freeze]
  s.homepage = "https://github.com/ruby-hl7/ruby-hl7".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6".freeze)
  s.rubyforge_project = "ruby-hl7".freeze
  s.rubygems_version = "2.5.2.1".freeze
  s.summary = "Ruby HL7 Library".freeze

  s.installed_by_version = "2.5.2.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>.freeze, [">= 11.0"])
      s.add_development_dependency(%q<rubyforge>.freeze, [">= 2.0.4"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 11.0"])
      s.add_dependency(%q<rubyforge>.freeze, [">= 2.0.4"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 11.0"])
    s.add_dependency(%q<rubyforge>.freeze, [">= 2.0.4"])
  end
end
