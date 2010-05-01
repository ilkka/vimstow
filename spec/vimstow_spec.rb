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
      within_construct do |c|
        c.directory 'stow' do
          c.file 'stow/addon/plugins/test.vim', 'test.vim content'
          out = capture_stdout { Vimstow::App.new(['stow', 'addon'], STDIN).run() }
          out.should be_empty
        end
        File.symlink?('plugins').should be_true
      end
    end

    it "should symlink top-level dir contents when top-level dirs exist" do
      within_construct do |c|
        c.directory 'stow' do
          c.file 'stow/addon/plugins/test.vim', 'test.vim content'
          c.directory 'plugins'
          out = capture_stdout { Vimstow::App.new(['stow', 'addon'], STDIN).run() }
          out.should be_empty
        end
        File.symlink?('plugins/test.vim').should be_true
      end
    end
    
    it "should symlink nested dir contents if nested dirs exist" do
      within_construct do |c|
        c.directory 'stow' do
          c.file 'stow/addon/foo/bar/test.vim', 'test.vim content'
          c.directory 'foo/bar'
          out = capture_stdout { Vimstow::App.new(['stow', 'addon'], STDIN).run() }
          out.should be_empty
        end
        File.symlink?('foo/bar/test.vim').should be_true
      end
    end
    
    it "should convert symlinks to dirs when a nested target dir is a symlink" do
      pending "write test"
    end

  end

  context "when unstowing" do
    it "should delete toplevel symlinked dirs if they belong to the addon" do
      pending "write specs"
    end
  end
end
