require "cake"

default :test

phony :test
target :test, desc: "Run tests" do |env|
  run "crystal", ["spec"], output: STDOUT
end

phony :docs
target :docs, desc: "Generate documentation" do |env|
  run "crystal", ["docs"], output: STDOUT
end

Cake.run
