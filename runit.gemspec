# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "runit/version"

Gem::Specification.new do |s|
  s.name        = "runit"
  s.version     = Runit::VERSION
  s.date        = "2016-07-18"
  s.summary     = "RunIt!"
  s.description = "Run It All At Console"
  s.authors     = ["trubachoff"]
  s.email       = ["trubachoff@gmail.com"]

  s.homepage    = "https://github.com/dealer-point/transit"
  s.license     = "MIT"

  s.require_paths = ['lib']
  s.files       = Dir["lib/**/*.rb"] +
                  Dir["configs/**/*.yaml"] +
                  ['LICENSE']

  s.executables = ["runit"]

end
