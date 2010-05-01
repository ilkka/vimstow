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
        opts.banner = "Usage: vimstow [options] <command> <addon> [<addon> ...]"
        opts.separator ""
        opts.separator "Commands:"
        opts.separator format("    %-33s%s", "stow", "Link addon")
        opts.separator format("    %-33s%s", "unstow", "Unlink addon")
        opts.separator "Options:"
        opts.on('-v', '--version', 'Output version and exit') do
          output_version
          exit 0
        end
        opts.on('-V', '--verbose', 'Be more verbose') { @options.verbose = true }
        opts.on('-q', '--quiet', 'Be quiet') { @options.quiet = true }
        opts.on('-n', '--no-act', 'Simulate without doing any changes') {  @options.simulate = true }
        opts.on_tail('-h', '--help', 'Output usage message') { puts @opts; exit }
      end
    end

    def run
      begin
        if parsed_options?
          puts "Start" if @options.verbose
          process_arguments
          output_options if @options.verbose
          output_arguments if @options.verbose
          process_command
          puts "Finished" if @options.verbose
        else
          puts @opts
          raise(RuntimeError, "Invalid options")
        end
      rescue ArgumentError => err
        puts err.message
        puts @opts
        raise
      end
    end

    protected

    def output_version
      puts "Vimstow v#{VERSION}"
    end

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
      raise(ArgumentError, "Too few arguments") unless @arguments.size >= 2
      @command = @arguments.shift
      @arguments.each do |arg|
        raise(ArgumentError, "#{arg} is not a directory") unless File.directory? arg
      end
    end

    def output_arguments
      puts "Arguments:\n"
      ap @arguments
    end

    def process_command
      case @command
      when "stow"
        @arguments.each {|arg| stow(arg)}
      when "unstow"
        @arguments.each {|arg| unstow(arg)}
      else
        raise(ArgumentError, "#{@command} is not a valid command")
      end
    end

    def stow(dir)
      Dir.glob(File.join dir, '*/').each do |subdir|
        stow_subdir(File.realpath(subdir), File.join('..', File.basename(subdir)))
      end
    end

    def unstow(dir)
      puts "Unstowing #{dir}" if @options.verbose
      Dir.glob(File.join dir, '*/').each do |contained|
        puts "Unstowing content #{contained}" if @options.verbose
        path = File.join('..', File.basename(contained))
        if File.symlink?(path) and File.realpath(path).split(File::SEPARATOR).include? dir
          puts "Deleting #{path}" if @options.verbose
          File.delete path unless @options.simulate
        elsif File.directory?(path)
          raise(RuntimeError, "Can't unstow nested dirs yet")
        end
      end
    end

    def stow_subdir(dir, targetdir)
      unless File.exists? targetdir
        link_dir(dir, targetdir)
      else
        if File.directory?(targetdir) and not File.symlink?(targetdir)
          link_contents(dir, targetdir)
        elsif File.symlink?(targetdir)
          dirify_and_relink_contents(targetdir)
          link_contents(dir, targetdir)
        else
          raise(RuntimeError, "Conflict: #{dir} vs. #{targetdir}")
        end
      end
    end

    def dirify_and_relink_contents(dir)
      contents = Dir.glob(File.join(dir, '*')).map {|d| File.basename d}
      puts "Deleting symlink #{dir}" if @options.verbose
      File.delete dir unless @options.simulate
      puts "Creating directory #{dir}" if @options.verbose
      Dir.mkdir dir unless @options.simulate
      contents.each do |c|
        tgt = File.join dir, c
        puts "Relinking #{c} to #{tgt}" if @options.verbose
        stow_subdir c, tgt unless @options.simulate
      end
    end

    def link_dir(dir, target)
      puts "Linking #{dir} to #{target}" if @options.verbose
      File.symlink dir, target unless @options.simulate
    end

    def link_contents(dir, tgtdir)
      Dir.glob(File.join dir, '*').each do |file|
        target = File.join(tgtdir, File.basename(file))
        if File.directory? target
          stow_subdir(file, target)
        else
          puts "Linking #{file} to #{target}" if @options.verbose
          File.symlink file, target unless @options.simulate
        end
      end
    end
  end
end

