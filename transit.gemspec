# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "transit/version"

Gem::Specification.new do |s|
  s.name        = "transit"
  s.version     = Transit::VERSION
  s.date        = "2016-07-18"
  s.summary     = "TransIt"
  s.description = "TransIt - search line in source files with russian letters"
  s.authors     = ["trubachoff"]
  s.email       = ["trubachoff@gmail.com"]

  s.homepage    = "https://github.com/dealer-point/transit"
  s.license     = "MIT"

  s.require_paths = ['lib']
  s.files       = Dir["lib/**/*.rb"] +
                  Dir["configs/**/*.yaml"] +
                  ['LICENSE']

  s.executables = ["transit"]

end
