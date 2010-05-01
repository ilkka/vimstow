Vimstow
=======

* Stow for vim plugins (http://github.com/ilkka/vimstow)

DESCRIPTION
-----------

This is a specialized sort-of-version of GNU stow that is meant for installing
additional plugins into your .vim dir.

FEATURES/PROBLEMS
-----------------

* Only stows for now. Does not unstow.

SYNOPSIS
--------

  $ cd ~/.vim
  $ mkdir stow
  $ cd stow
  $ tar xzf ~/some-vim-addon.tar.gz
  $ ls some-vim-addon
  doc plugin README.txt syntax
  $ vimstow stow some-vim-addon

Et voilá. Some-vim-addon should now be installed.

REQUIREMENTS
------------

* Ruby 1.9
* awesome_print (gem install awesome_print)

For testing:

* Construct (gem install devver-construct --source http://gems.github.com)

INSTALL
-------

* Run "rake install_gem"

DEVELOPERS
----------

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

LICENSE
-------

(The MIT License)

Copyright (c) 2010 Ilkka Laukkanen

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
