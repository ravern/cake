require "option_parser"

class Cake::CLI
  def initialize
    @env = Env.new
    @command = :build
    @targets = [] of String

    @parser = OptionParser.new
    @parser.banner = "Usage: cake [options] [targets]"
    @parser.on("-h", "--help", "Print usage and help information") { @command = :help }
    @parser.on("-v", "--verbose", "Print more information about build") { @env.verbose = true }
    @parser.on("-l", "--list", "Lists information about targets") { @command = :list }
    @parser.on("-t", "--timeout SECONDS", "Duration before file is outdated") do |timeout|
      @env.timeout = timeout.to_i? || raise OptionParser::InvalidOption.new("--timeout")
    end
    @parser.unknown_args do |targets, args|
      @targets = targets
      @env.args = args
    end
  end

  def run
    begin
      @parser.parse!
    rescue exception : OptionParser::Exception
      return help(exception)
    end

    if @command == :help
      return help
    end

    if @targets.empty?
      if default = Targets::INSTANCE.default
        @targets << default
      elsif target = Targets::INSTANCE.all.first_value?
        @targets << target.name
      end
    end

    begin
      Targets::INSTANCE.validate(@targets)
    rescue exception : ValidationError
      return help(exception)
    end

    if @command == :list
      return list
    end

    @targets.each do |name|
      Targets::INSTANCE.all[name].build(@env)
    end
  end

  private def list
    puts Targets::INSTANCE.to_s
  end

  private def help(exception : Exception? = nil)
    if exception
      puts "Error: #{exception.message}"
    end
    puts @parser.to_s
  end
end
