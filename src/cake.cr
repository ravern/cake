require "./cake/cli"

module Cake
  def self.run
    Cake::CLI.new.run
  end
end
