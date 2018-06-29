require "./cake/dsl"
require "./cake/env"
require "./cake/target"
require "./cake/cli"

module Cake
  class ValidationError < Exception
    def initialize(message : String? = nil, cause : Exception? = nil)
      super(message, cause)
    end

    def initialize(not_found : String, needed_by : String? = nil)
      super(String.build do |s|
        s << "Target "
        s << not_found
        s << " not found"
        if needed_by
          s << " needed by "
          s << needed_by
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
      if all.empty?
        raise ValidationError.new("No targets defined.")
      end

      names.each do |name|
        all[name]? || raise ValidationError.new(not_found: name)
      end

      if default = @default
        all[default]? || raise ValidationError.new(not_found: default)
      end

      all.each do |name, target|
        target.deps.each do |dep|
          if !all[dep]? && !File.file?(dep)
            raise ValidationError.new(dep, target.name)
          end
        end
      end
    end
  end

  def self.run
    Cake::CLI.new.run
  end
end

extend Cake::DSL
