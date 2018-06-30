require "cake"

default :test

phony :test
target :test do |env|
  run "crystal", ["spec"], output: STDOUT
end

Cake.run
