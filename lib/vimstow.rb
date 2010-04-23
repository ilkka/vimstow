# = Vimstow
# == Copyright
#
#   Vimstow is Copyright (c) 2010 Ilkka Laukkanen. Licensed under the MIT
#   License: <http://www.opensource.org/licenses/mit-license.php>.
#
require 'optparse'
require 'ostruct'
require 'ap'

module Vimstow
  class App
    VERSION = '1.0.0'

    attr_reader :options

    def initialize(arguments, stdin)
      @arguments = arguments
      @stdin = stdin
      @options = OpenStruct.new({ :verbose => false, :quiet => false })
      @opts = OptionParser.new do |opts|
        opts.banner = "Usage: vimstow [options] <addon>"
        opts.separator ""
        opts.separator "Options:"
        opts.on('-v', '--version', 'Output version and exit') do
          output_version
          exit 0
        end
        opts.on('-V', '--verbose', 'Be more verbose') { @options.verbose = true }
        opts.on('-q', '--quiet', 'Be quiet') { @options.quiet = true }
        opts.on_tail('-h', '--help', 'Output usage message') { puts @opts; exit }
      end
    end

    def run
      begin
        if parsed_options? && arguments_valid?
          puts "Start" if @options.verbose
          process_arguments
          output_options if @options.verbose
          output_arguments if @options.verbose
          process_command
          puts "Finished" if @options.verbose
        else
          puts @opts
          exit 1
        end
      rescue ArgumentError => err
        puts err.message
        puts @opts
        exit 2
      end
    end

    protected

    def parsed_options?
      @opts.parse!(@arguments) rescue return false
      process_options
    end

    def process_options
      @options.verbose = false if @options.quiet
      true
    end

    def output_options
      puts "Options:\n"
      ap @options
    end

    def process_arguments
      @arguments.each do |arg|
        raise(ArgumentError, "#{arg} is not a directory") unless File.directory? arg
      end
    end

    def output_arguments
      puts "Arguments:\n"
      ap @arguments
    end

    def arguments_valid?
      true
    end

    def process_command
    end
  end
end

