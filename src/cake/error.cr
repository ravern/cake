module Cake
  class Error < Exception
  end

  class BuildError < Error
    property code

    def initialize(@code : Int32)
      super("Exited with error code #{code}")
    end
  end

  class ValidationError < Error
  end

  class NotFoundError < ValidationError
    property not_found
    property needed_by

    def initialize(@not_found : String, @needed_by : String? = nil)
      super(String.build do |s|
        s << "Target "
        s << not_found
        s << " not found,"
        if needed_by
          s << " needed by "
          s << needed_by
        end
      end)
    end
  end
end
