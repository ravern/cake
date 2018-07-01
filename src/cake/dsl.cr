require "process"

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
    Targets::INSTANCE.phonies << name.to_s
  end

  # Defines a new target.
  def target(name : String | Symbol, deps : Array(String | Symbol) = [] of String | Symbol, desc : String = "", &build : Env ->)
    Targets::INSTANCE.all[name.to_s] = Target.new(name.to_s, deps.map(&.to_s), desc, &build)
  end

  # Runs an external command.
  #
  # Raises a `BuildError` if an error occured while running. If the `quiet` flag
  # is set, the command that was run will not be displayed.
  def run(command : String, args = nil, env : Process::Env = nil, clear_env : Bool = false, shell : Bool = false, input : Bool = true, output : Bool = true, error : Bool = true, chdir : String? = nil, quiet : Bool = false)
    unless quiet
      STDOUT << "#{command} "
      args.each do |arg|
        quote = arg.empty? || /.*[@&$*! ].*/.match(arg) ? "'" : ""
        STDOUT << "#{quote}#{arg}#{quote} "
      end
      STDOUT << "\n"
    end

    status = Process.run(command, args, env, clear_env, shell, input ? STDIN : Process::Redirect::Close, output ? STDOUT : Process::Redirect::Close, error ? STDERR : Process::Redirect::Close, chdir)
    if !status.normal_exit?
      raise RunError.new(abnormal: true)
    elsif !status.success?
      raise RunError.new(exit_code: status.exit_code)
    end
  end
end
