class Cake::Target
  getter name
  getter deps
  getter desc

  def initialize(@name : String, @deps : Array(String), @desc : String, &@build : Env ->)
  end
  
  def build(env : Env)
    @build.call(env)
  end
end
