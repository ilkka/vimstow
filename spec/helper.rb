require File.expand_path(File.dirname(__FILE__) + '/../lib/vimstow.rb')

require 'spec'
require 'construct'

# redirect stdout
require 'stringio'
module Kernel
  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    return out.string
  ensure
    $stdout = STDOUT
  end
end

