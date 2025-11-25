# -*- encoding: utf-8 -*-
# stub: route_translator 7.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "route_translator".freeze
  s.version = "7.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Geremia Taglialatela".freeze, "Enric Lluelles".freeze, "Raul Murciano".freeze]
  s.date = "2019-12-26"
  s.description = "Translates the Rails routes of your application into the languages defined in your locale files".freeze
  s.email = ["tagliala.dev@gmail.com".freeze, "enric@lluell.es".freeze]
  s.homepage = "https://github.com/enriclluelles/route_translator".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new("~> 2.3".freeze)
  s.rubygems_version = "2.5.2.1".freeze
  s.summary = "Translate your Rails routes in a simple manner".freeze

  s.installed_by_version = "2.5.2.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>.freeze, ["< 6.1", ">= 5.0.0.1"])
      s.add_runtime_dependency(%q<activesupport>.freeze, ["< 6.1", ">= 5.0.0.1"])
      s.add_runtime_dependency(%q<addressable>.freeze, ["~> 2.7"])
      s.add_development_dependency(%q<appraisal>.freeze, ["~> 2.2"])
      s.add_development_dependency(%q<byebug>.freeze, ["< 12", ">= 10.0"])
      s.add_development_dependency(%q<coveralls_reborn>.freeze, ["~> 0.14.0"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.13"])
      s.add_development_dependency(%q<rails>.freeze, ["< 6.1", ">= 5.0.0.1"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.78.0"])
      s.add_development_dependency(%q<rubocop-performance>.freeze, ["~> 1.5"])
      s.add_development_dependency(%q<rubocop-rails>.freeze, ["~> 2.4"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.17.1"])
    else
      s.add_dependency(%q<actionpack>.freeze, ["< 6.1", ">= 5.0.0.1"])
      s.add_dependency(%q<activesupport>.freeze, ["< 6.1", ">= 5.0.0.1"])
      s.add_dependency(%q<addressable>.freeze, ["~> 2.7"])
      s.add_dependency(%q<appraisal>.freeze, ["~> 2.2"])
      s.add_dependency(%q<byebug>.freeze, ["< 12", ">= 10.0"])
      s.add_dependency(%q<coveralls_reborn>.freeze, ["~> 0.14.0"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.13"])
      s.add_dependency(%q<rails>.freeze, ["< 6.1", ">= 5.0.0.1"])
      s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.78.0"])
      s.add_dependency(%q<rubocop-performance>.freeze, ["~> 1.5"])
      s.add_dependency(%q<rubocop-rails>.freeze, ["~> 2.4"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.17.1"])
    end
  else
    s.add_dependency(%q<actionpack>.freeze, ["< 6.1", ">= 5.0.0.1"])
    s.add_dependency(%q<activesupport>.freeze, ["< 6.1", ">= 5.0.0.1"])
    s.add_dependency(%q<addressable>.freeze, ["~> 2.7"])
    s.add_dependency(%q<appraisal>.freeze, ["~> 2.2"])
    s.add_dependency(%q<byebug>.freeze, ["< 12", ">= 10.0"])
    s.add_dependency(%q<coveralls_reborn>.freeze, ["~> 0.14.0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.13"])
    s.add_dependency(%q<rails>.freeze, ["< 6.1", ">= 5.0.0.1"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.78.0"])
    s.add_dependency(%q<rubocop-performance>.freeze, ["~> 1.5"])
    s.add_dependency(%q<rubocop-rails>.freeze, ["~> 2.4"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.17.1"])
  end
end
