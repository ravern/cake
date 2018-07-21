# Represents an environment for building a target.
struct Cake::Env
  # Returns whether the output should be verbose.
  getter verbose = false
  protected setter verbose

  # Returns the arguments that were passed after the `--`.
  getter args = [] of String
  protected setter args

  # Returns the name of the target.
  getter name = ""
  protected setter name

  # Returns the dependencies.
  getter deps = [] of String
  protected setter deps

  # Returns the file dependencies that were modified.
  getter modified_deps = [] of String
  protected setter modified_deps
end
