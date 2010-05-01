require File.expand_path(File.dirname(__FILE__) + '/helper.rb')

describe "Vimstow" do
  it "should output its version with -v" do
    args = ['-v']
    vs = Vimstow::App.new(args, STDIN)
    out = capture_stdout do
      lambda { vs.run() }.should raise_exception(SystemExit) {|e| e.status.should == 0}
    end
    out.should match /^Vimstow v[0-9]+\.[0-9]+\.[0-9]+/
  end

  context "when stowing" do
    it "should symlink top-level dirs when they don't exist" do
      pending "write test"
    end
    it "should symlink top-level dir contents when top-level dirs exist" do
      pending "write test"
    end
    it "should symlink nested dir contents if nested dirs exist" do
      pending "write test"
    end
    it "should convert symlinks to dirs when a nested target dir is a symlink" do
      pending "write test"
    end
  end

  context "when unstowing"
end
