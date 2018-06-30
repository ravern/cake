module Cake::DSL
  # Sets the given target to be the default target.
  #
  # If a default target is not set, it is automatically set to the first target
  # that was defined.
  def default(name : String)
    Targets::INSTANCE.default = name
  end

  # Adds the given target to the phony targets.
  #
  # Phony targets are targets that will always be rebuilt, no matter when their
  # files exist or when their dependencies are not rebuilt.
  def phony(name : String)
    Targets::INSTANCE.phony << name
  end

  # Adds the given targets to the phony targets.
  #
  # See `phony(name : String)` for more information.
  def phony(names : Array(String))
    Targets::INSTANCE.phony += names
  end

  # Defines a new target.
  def target(name : String | Symbol, deps : Array(String | Symbol)? = nil, desc : String = "", &build : Env ->)
    deps = (deps || [] of String | Symbol).map do |dep|
      dep.to_s
    end
    Targets::INSTANCE.all[name] = Target.new(name.to_s, deps, desc, &build)
  end
end
