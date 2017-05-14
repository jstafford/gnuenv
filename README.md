# gnuenv
For macOS switch to GNU commands with gnuenv on, back to BSD with gnuenv off.

To install, use brew:
```
brew install gnuenv
```


Then in any shell you want to use GNU tools, source gnuenv as follows:
```
source \usr\local\bin\gnuenv
```

gnuenv is just a bash shell script, so it is pretty easy to understand how it
works, and to modify it if you need to.

To change to using GNU tools (gnu versions of everything from base64 to yes):
```
gnuenv on
```

This command does four things:
1. Saves off the environment variables it about to modify, in case you want to
  use ```gnuenv off```
2. Bootstraps your system to have all the necessary GNU tools (in case you are
  using gnuenv without installing it via brew first)
3. Modifies environment variables so that GNU tools will be used in preference
  to BSD ones. Mainly this involves changing the path, but some compiler
  environment variables are also modified. See docs for details.
4. Modifies your command prompt to show ```gnuenv``` so you remember that
  everything works a little differently in this shell.

When you are ready to go back to BSD land, either just close that shell, or type:
```
gnuenv off
```

Acknowledgements
----------------

This project heavily inspired by [VirtualEnv](https://virtualenv.pypa.io) for
python by Ian Bicking. It would not be possible at all without the amazing
[Homebrew](https://brew.sh/) project, and all the brew bottles for the GNU
tools that this project exposes.

This

This project started from my desire to experiment with
[OpenWrt](https://openwrt.org/), and my initial frustration at getting the build
environment set up on my mac. As it turns out, this is a sledge hammer where a
ball peen would have fixed the issue I had with OpenWrt, but was far enough down
this path when I realized that, I figured I might as well finish it off.

License
-------
This is project is licensed under version 1 of the GNU General Public License,
which isn't a license I would normally use, but I wanted to make it easy for any
GPL based project (like OpenWrt) to include my shell script directly, whatever
version of GPL they are on (1, 2, or 3).
