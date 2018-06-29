require "./cake/error"
require "./cake/dsl"
require "./cake/env"
require "./cake/target"
require "./cake/cli"

module Cake
  private class Targets
    INSTANCE = new

    property default : String?
    property phony = [] of String
    property all = {} of String => Target

    def validate(names : Array(String))
      if all.empty?
        raise ValidationError.new("No targets defined")
      end

      names.each do |name|
        all[name]? || raise NotFoundError.new(name)
      end

      if default = @default
        all[default]? || raise NotFoundError.new(default)
      end

      all.each do |name, target|
        target.deps.each do |dep|
          if !all[dep]? && !File.file?(dep)
            raise NotFoundError.new(dep, target.name)
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
