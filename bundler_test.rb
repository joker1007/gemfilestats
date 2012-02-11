require "rubygems"
require "bundler"
require "pry"
require "pp"

definition = Bundler::Dsl.evaluate("Gemfile", nil, nil)
binding.pry
