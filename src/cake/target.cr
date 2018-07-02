module Cake
  # Represents a target to be built.
  class Target
    # Returns the name of the target.
    getter name

    # Returns the dependencies of the target.
    getter deps

    # Returns the description of the target.
    getter desc

    def initialize(@name : String, @deps : Array(String), @desc : String, &@build : Env ->)
    end

    # Builds the target.
    #
    # The target will not be build if it is deemed up to date. This means that
    # none of its target dependencies were rebuilt, and none of its file
    # dependencies were modified after the target file was last modified.
    def build(env : Env) : Bool
      env.name = @name
      env.deps = @deps
      env.modified_deps = [] of String

      rebuild = false

      if Targets::INSTANCE.phonies.includes?(@name)
        rebuild = true
      end

      begin
        modification_time = File.info(name).modification_time
      rescue exception : Errno
        rebuild = true
      end

      @deps.each do |dep|
        if target = Targets::INSTANCE.all[dep]?
          if target.build(env)
            rebuild = true
          end
        elsif modification_time
          dep_modification_time = File.info(dep).modification_time
          if dep_modification_time.epoch > modification_time.epoch
            rebuild = true
            env.modified_deps << dep
          end
        end
      end

      unless rebuild
        if env.verbose
          puts "Target #{@name} up to date"
        end
        return false
      end

      if env.verbose
        puts "Building target #{@name}..."
      end

      @build.call(env)
      true
    end
  end
end
