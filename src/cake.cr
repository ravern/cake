require "./cake/dsl"
require "./cake/env"
require "./cake/target"
require "./cake/cli"

module Cake
  class ValidationError < Exception
    def initialize(message : String? = nil, cause : Exception? = nil)
      super(message, cause)
    end

    def initialize(not_found_target : String, needed_by_target : String? = nil)
      super(String.build do |s|
        s << "Target "
        s << not_found_target
        s << " not found"
        if needed_by_target
          s << " needed by "
          s << needed_by_target
        end
      end)
    end
  end

  private class Targets
    INSTANCE = new

    property default : String?
    property phony = [] of String
    property all = {} of String => Target

    def validate(names : Array(String))
      names.each do |name|
        all[name]? || raise ValidationError.new(name)
      end

      all.each do |name, target|
        target.deps.each do |dep|
          all[dep]? || raise ValidationError.new(dep, target.name)
        end
      end
    end
  end

  def self.run
    Cake::CLI.new.run
  end
end
