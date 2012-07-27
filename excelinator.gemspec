# -*- encoding: utf-8 -*-
require "lib/excelinator/version"

Gem::Specification.new do |s|
  s.name        = "excelinator"
  s.version     = Excelinator::VERSION
  s.authors     = %W(chrismo)
  s.email       = %W(chrismo@clabs.org)
  s.homepage    = "https://github.com/livingsocial/excelinator"
  s.summary     = %q{Excel Converter}
  s.description = %q{convert your csv data and html tables to excel data}

  s.add_dependency('spreadsheet', '0.6.8') # surpass another option here
  s.add_dependency('fastercsv')            # TODO not for ruby 1.9, right?
  
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')

  s.files         = `git ls-files lib/* README.md`.split("\n")
  s.require_paths = %W(lib)
end
