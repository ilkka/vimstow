# = Vimstow
# == Copyright
#
#   Vimstow is Copyright (c) 2010 Ilkka Laukkanen. Licensed under the MIT
#   License: <http://www.opensource.org/licenses/mit-license.php>.
#
require 'optparse'
require 'ostruct'

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
      if parsed_options? && arguments_valid?
        puts "Start" if @options.verbose
        output_options if @options.verbose
        process_arguments
        process_command
        puts "Finished" if @options.verbose
      else
        puts @opts
        exit 1
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
      @options.marshal_dump.each do |name,val|
        puts "\t#{name}\t= #{val}\n"
      end
    end

    def process_arguments
      true
    end

    def arguments_valid?
      true
    end

    def process_command
    end
  end
end

