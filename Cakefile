require "cake"

default :test

phony :test
target :test, desc: "Run tests" do |env|
  run "crystal", ["spec"]
end

phony :docs
target :docs, desc: "Generate documentation" do |env|
  run "crystal", ["docs"]
end

Cake.run
