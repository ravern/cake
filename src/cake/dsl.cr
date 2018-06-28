module Cake::DSL
  def target(name : String | Symbol, deps : Array(String | Symbol)? = nil, desc : String = "", &block : Env ->)
    deps = (deps || [] of String | Symbol).map do |dep|
      dep.to_s
    end
    Targets::INSTANCE.all[name] = Target.new(name.to_s, deps, desc, &block)
  end
end

extend Cake::DSL
