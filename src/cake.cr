require "./cake/*"

module Cake
  # Runs the program.
  def self.run
    CLI.new.run
  end
end

extend Cake::DSL
