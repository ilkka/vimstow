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
      within_construct do |c|
        c.directory 'stow' do
          c.file 'stow/addon1/foo/bar/test.vim', 'test.vim 1 content'
          c.file 'stow/addon2/foo/baz/test.vim', 'test.vim 2 content'
          Vimstow::App.new(['stow', 'addon1'], STDIN).run()
          File.symlink?('../foo').should be_true
          out = capture_stdout { Vimstow::App.new(['stow', 'addon2'], STDIN).run() }
          out.should be_empty
        end
        File.symlink?('foo').should be_false
        File.directory?('foo').should be_true
        File.symlink?('foo/bar').should be_true
        File.symlink?('foo/baz').should be_true
      end
    end

  end

  context "when unstowing" do

    it "should delete toplevel symlinked dirs if they belong to the addon" do
      within_construct do |c|
        c.directory 'stow' do
          c.file 'stow/addon/foo/bar.vim', 'bar.vim content'
          Vimstow::App.new(['stow', 'addon'], STDIN).run()
          File.symlink?('../foo').should be_true
          out = capture_stdout { Vimstow::App.new(['unstow', 'addon'], STDIN).run() }
          out.should be_empty
        end
        File.exist?('foo').should be_false
      end
    end

    it "should delete content links when toplevel dir is a directory" do
      within_construct do |c|
        c.directory 'stow' do
          c.file 'foo/bar.vim'
          c.file 'stow/addon/foo/baz.vim', 'baz.vim content'
          Vimstow::App.new(['stow', 'addon'], STDIN).run()
          File.symlink?('../foo/baz.vim').should be_true
          out = capture_stdout { Vimstow::App.new(['unstow', 'addon'], STDIN).run() }
          out.should be_empty
        end
        File.directory?('foo').should be_true
        File.exist?('foo/bar.vim').should be_true
        File.exist?('foo/baz.vim').should be_false
      end
    end

  end
end
