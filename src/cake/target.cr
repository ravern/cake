class Cake::Target
  getter name
  getter deps
  getter desc

  def initialize(@name : String, @deps : Array(String), @desc : String, &@build : Env ->)
  end
  
  def build(env : Env)
    rebuild = false

    if Targets::INSTANCE.phony.includes?(@name)
      rebuilt = true
    end

    begin
      modification_time = File.info(name).modification_time
    rescue exception : Errno
      rebuild = true
    end

    @deps.each do |dep|
      if target = Targets::INSTANCE.all[dep]?
        rebuild = true if target.build(env)
      else
        dep_modification_time = File.info(dep).modification_time
        if dep_modification_time.epoch - modification_time.not_nil!.epoch > env.timeout
          rebuild = true
        end
      end
    end

    unless rebuild
      if env.verbose
        puts "Target #{@name} up to date"
      end
      return
    end

    if env.verbose
      puts "Building target #{@name}..."
    end

    @build.call(env)
  end
end
