module Cake
  # All errors raised will inherit from `Error`.
  class Error < Exception
  end

  # Raised when an error occurs inside `build` block of a `Target`.
  class BuildError < Error
  end

  # Raised when an error occurs while running a shell command.
  #
  # It includes the exit code of the shell command that failed to run.
  class RunError < BuildError
    getter abnormal = nil
    getter exit_code = nil

    def initialize(@abnormal : Bool)
      super("Exited abnormally")
    end

    def initialize(@exit_code : Int32)
      super("Exited with exit code #{@exit_code}")
    end
  end

  # Raised when target definition is invalid.
  class ValidationError < Error
  end

  # Raised when a target is not found.
  #
  # It can also include whether the target that was not found was a dependency
  # of another target, indicated by `needed_by`.
  class NotFoundError < ValidationError
    getter not_found
    getter needed_by

    def initialize(@not_found : String, @needed_by : String? = nil)
      super(String.build do |s|
        s << "Target "
        s << @not_found
        s << " not found"
        if needed_by
          s << ", needed by "
          s << @needed_by
        end
      end)
    end
  end
end
