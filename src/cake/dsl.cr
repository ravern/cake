module Cake::DSL
  # Sets the given target to be the default target.
  #
  # If a default target is not set, it is automatically set to the first target
  # that was defined.
  def default(name : String | Symbol)
    Targets::INSTANCE.default = name.to_s
  end

  # Adds the given target to the phony targets.
  #
  # Phony targets are targets that will always be rebuilt, no matter when their
  # files exist or when their dependencies are not rebuilt.
  def phony(name : String | Symbol)
    Targets::INSTANCE.phony << name.to_s
  end

  # Adds the given targets to the phony targets.
  #
  # See `phony(name : String)` for more information.
  def phony(names : Array(String | Symbol))
    Targets::INSTANCE.phony += names.map(&.to_s)
  end

  # Defines a new target.
  def target(name : String | Symbol, deps : Array(String | Symbol) = [] of String | Symbol, desc : String = "", &build : Env ->)
    Targets::INSTANCE.all[name] = Target.new(name.to_s, deps.map(&.to_s), desc, &build)
  end
end
