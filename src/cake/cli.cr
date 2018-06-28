require "option_parser"

class Cake::CLI
  private class Options
    property verbose = false
    property timeout = 0
    property command = :build
    property args = [] of String
  end

  def initialize
    @options = Options.new
    @parser = OptionParser.new
    @parser.banner = "Usage: cake [options] [targets]"
    @parser.on("-h", "--help", "Print usage and help information") { @options.command = :help }
    @parser.on("-v", "--verbose", "Print more information about build") { @options.verbose = true }
    @parser.on("-l", "--list", "Lists information about targets") { @options.command = :list }
    @parser.on("-t", "--timeout SECONDS", "Duration before file is outdated") do |timeout|
      @options.timeout = timeout.to_i? || raise OptionParser::InvalidOption.new("--timeout")
    end
    @parser.unknown_args { |args| @options.args = args }
  end

  def run
    begin
      @parser.parse!
    rescue exception : OptionParser::Exception
      return help(exception)
    end

    if @options.command == :help
      return help
    end

    if @options.args.empty?
      if Targets::INSTANCE.all.empty?
        return help(ValidationError.new("No targets provided"))
      end
      @options.args << Targets::INSTANCE.all.first_value.name
    end

    begin
      Targets::INSTANCE.validate(@options.args)
    rescue exception : ValidationError
      return help(exception)
    end

    if @options.command == :list
      return list
    end

    env = Env.new(
      @options.verbose,
      @options.timeout
    )

    @options.args.each do |name|
      Targets::INSTANCE.all[name].build(env)
    end
  end

  protected def list
    puts Targets::INSTANCE.to_s
  end

  protected def help(exception : Exception? = nil)
    if exception
      puts "Error: #{exception.message}"
    end
    puts @parser.to_s
  end
end
