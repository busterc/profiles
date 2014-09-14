# profiles

dotfiles, system defaults and more

## Prerequisites
- X
  - [git](http://git-scm.com/book/en/Getting-Started-Installing-Git)
    - dotfiles/profile_x
  - [Node / NPM](https://github.com/joyent/node/wiki/installation)
    - setup.sh
  - [ImageMagick](http://www.imagemagick.org/script/binary-releases.php)
    - dotfiles/profile_x
  - [ActivePerl / PPM (5.16)](http://www.activestate.com/activeperl/downloads)
    - dotfiles/profile_x
  - [Sublime Text 2](http://www.sublimetext.com/2)
    - dotfiles/profile_osx
    - dotfiles/profile_linux
    - dotfiles/profile_msys

- OS X
  - [Xcode](https://developer.apple.com/xcode/downloads/)
    - dotfiles/profile_osx
  - [MacPorts](https://www.macports.org/install.php)
    - dotfiles/profile_osx
  - [Android SDK](https://developer.android.com/sdk/index.html)
    - dotfiles/profile_osx
  - [Heroku Toolbelt](https://toolbelt.heroku.com/)
    - dotfiles/profile_osx
  - [Chrome](https://www.google.com/chrome/browser/)
    - dotfiles/profile_osx

- MSYS
  - [Chrome](https://www.google.com/chrome/browser/)
    - dotfiles/profile_msys

- Linux
  - Chromium `sudo apt-get install chromium-browser`
    - dotfiles/profile_linux


## Setup
```sh
$ git clone https://github.com/busterc/profiles.git ~/.profiles
$ cd ~/.profiles
$ [sudo] ./setup.sh <osx|linux|msys>
```

## FYI
- [`setup.sh`](setup.sh) creates symlinked dotfiles in `~/`. Therefore, any existing dotfiles will be copied to `backup` under newly created date-time named directories, e.g. `./backup/2012-12-20-235959`
- When setting up OSX you'll also apply several system defaults from [`init/osx`](init/osx)
- `private` is where you put all your, you know, private stuff. Notice that [`private/.gitignore`](private/.gitignore) prevents all files in that directory from committing.
- https://dotfiles.github.io/


## License
The MIT License (MIT)

Copyright (c) 2014 Buster Collings

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
