require File.expand_path(File.dirname(__FILE__) + '/helper.rb')

describe "Vimstow" do
  it "should output its version with -v" do
    pending "write test"
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
