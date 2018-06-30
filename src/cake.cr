require "./cake/*"

module Cake
  private class Targets
    INSTANCE = new

    property default : String?
    property phonies = [] of String
    property all = {} of String => Target

    def validate(names : Array(String))
      if all.empty?
        raise ValidationError.new("No targets defined")
      end

      names.each do |name|
        unless all[name]?
          raise NotFoundError.new(name)
        end
      end

      if default = @default
        unless all[default]?
          raise NotFoundError.new(default)
        end
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

  # Runs the program.
  def self.run
    CLI.new.run
  end
end

extend Cake::DSL
