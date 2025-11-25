# -*- encoding: utf-8 -*-
# stub: origami 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "origami".freeze
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Guillaume Delugr\u{e9}".freeze]
  s.date = "2017-10-07"
  s.description = "Origami is a pure Ruby library to parse, modify and generate PDF documents.".freeze
  s.email = "origami@subvert.technology".freeze
  s.executables = ["pdfsh".freeze, "pdf2pdfa".freeze, "pdf2ruby".freeze, "pdfcop".freeze, "pdfmetadata".freeze, "pdfdecompress".freeze, "pdfdecrypt".freeze, "pdfencrypt".freeze, "pdfexplode".freeze, "pdfextract".freeze]
  s.files = ["bin/pdf2pdfa".freeze, "bin/pdf2ruby".freeze, "bin/pdfcop".freeze, "bin/pdfdecompress".freeze, "bin/pdfdecrypt".freeze, "bin/pdfencrypt".freeze, "bin/pdfexplode".freeze, "bin/pdfextract".freeze, "bin/pdfmetadata".freeze, "bin/pdfsh".freeze]
  s.homepage = "http://github.com/gdelugre/origami".freeze
  s.licenses = ["LGPL-3.0+".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1".freeze)
  s.rubygems_version = "2.5.2.1".freeze
  s.summary = "Ruby framework to manipulate PDF documents".freeze

  s.installed_by_version = "2.5.2.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<colorize>.freeze, ["~> 0.7"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
    else
      s.add_dependency(%q<colorize>.freeze, ["~> 0.7"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
    end
  else
    s.add_dependency(%q<colorize>.freeze, ["~> 0.7"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
  end
end
