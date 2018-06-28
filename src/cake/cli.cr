require "option_parser"

class Cake::CLI
  private class Options
    property verbose = false
    property timeout = 0
    property command = :build
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

    begin
      Targets::INSTANCE.validate
    rescue exception : ValidationError
      return help(exception)
    end

    if @options.command == :list
      return list
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
