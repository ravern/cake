struct Cake::Env
  property verbose = false
  property timeout = 5
  property args = [] of String

  property name = ""
  property deps = [] of String
  property modified_deps = [] of String
end
