require "./cake/target"
require "./cake/cli"

module Cake
  class ValidationError < Exception
  end

  private class Targets
    INSTANCE = new

    property default : String?
    property phony = [] of String
    property all = {} of String => Target

    def validate
    end
  end

  def self.run
    Cake::CLI.new.run
  end
end
