# This file must be used with "source \usr\local\bin\gnuenv" *from bash*
# you cannot run it directly

gnuenv_bootstrapBrew () {
  # Install brew (if necessary).
  if ! hash brew 2>/dev/null ; then
    echo "Starting installation of Homebrew . . ."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

# Dependencies are commented out, since they
# will be installed automatically, and the
# fewer items in this list, the less time
# spent checking required bottles.
gnuenv_requiredBottles=(
#  "autoconf"
  "automake"
  "binutils"
  "coreutils"
  "findutils"
  "gawk"
#  "gettext"
#  "gmp"
  "gnu-getopt"
  "gnu-indent"
  "gnu-sed"
  "gnu-tar"
  "gnu-time"
  "gnu-units"
  "gnu-which"
  "gnutls"
  "grep"
#  "icu4c"
#  "libffi"
#  "libtasn1"
  "libtool"
#  "libunistring"
   "makedepend"
#  "mpfr"
#  "nettle"
  "openssl"
#  "p11-kit"
#  "pcre"
  "perl"
#  "pkg-config"
  "python"
#  "readline"
#  "scons"
#  "sphinx-doc"
  "sqlite"
#  "swig"
  "subversion"
  "wget"
)

gnuenv_bootstrapBrewBottles () {
  # Use brew to install a full set of GNU based development tools.
  local requiredBottle
  echo "Checking required bottles . . . "
  for requiredBottle in "${gnuenv_requiredBottles[@]}" ; do
    if ! brew ls --versions "${requiredBottle}" > /dev/null ; then
      echo "Staring install of ${requiredBottle} . . . "
      brew install "${requiredBottle}"
    fi
  done
}

gnuenv_bootstrap () {
  echo "Starting gnuenv bootstrap . . ."
  gnuenv_bootstrapBrew
  # do brew update before gnuenv_bootstrapBrewBottles, because
  # the behavior of brew ls returning a useful exit code was
  # not present in old versions of brew
  echo "Staring brew update . . . "
  brew update
  gnuenv_bootstrapBrewBottles
  # Always upgrade brew, since the only way to stay up to date, secure,
  # and in a working environment is frequent little changes, rather than
  # infrequent big changes.
  echo "Staring brew upgrade . . . "
  brew upgrade
  # Always run brew doctor after an upgrade, because the easiest time to
  # fix brew problems is when they first manifest. The longer they go,
  # the harder they are to figure out.
  echo "Staring brew doctor . . . "
  brew doctor
}


gnuenv_off () {
  # reset saved environment variables
  # ! [ -z ${VAR+_} ] returns true if VAR is declared at all
  if ! [ -z "${gnuenvSavedPath+_}" ] ; then
    PATH="$gnuenvSavedPath"
    export PATH
    unset gnuenvSavedPath
  fi

  if ! [ -z "${gnuenvSavedManpath+_}" ] ; then
    MANPATH="$gnuenvSavedManpath"
    export MANPATH
    unset gnuenvSavedManpath
  fi

  if ! [ -z "${gnuenvSavedLDFlags+_}" ] ; then
    LDFLAGS="$gnuenvSavedLDFlags"
    export LDFLAGS
    unset gnuenvSavedLDFlags
  fi

  if ! [ -z "${gnuenvSavedCPPFlags+_}" ] ; then
    CPPFLAGS="$gnuenvSavedCPPFlags"
    export CPPFLAGS
    unset gnuenvSavedCPPFlags
  fi

  if ! [ -z "${gnuenvSavedPkgConfigPath+_}" ] ; then
    PKG_CONFIG_PATH="$gnuenvSavedPkgConfigPath"
    export PKG_CONFIG_PATH
    unset gnuenvSavedPkgConfigPath
  fi

  if ! [ -z "${gnuenvSavedPS1+_}" ] ; then
    PS1="$gnuenvSavedPS1"
    export PS1
    unset gnuenvSavedPS1
  fi

  # This should detect bash and zsh, which have a hash command that must
  # be called to get it to forget past commands.  Without forgetting
  # past commands the $PATH changes we made may not be respected
  if [ -n "${BASH-}" ] || [ -n "${ZSH_VERSION-}" ] ; then
    hash -r 2>/dev/null
  fi

}

gnuenv_on () {
  # Activate gnuenv. Accepts three parameters:
  # $1 (skip) is either 1 to indicate bootstrapping should be skipped
  #  or 0 to indicate that bootstrapping should proceed normally.
  # $2 (promptSet) is either 0 to indicate that there is no custom prompt
  #  or 1 to indicate that there is a custom prompt.
  # $3 (promptValue) is a user specified string, which could be an empty
  #  string.

  # check if already run, if so, do noting
  if [ -n "${gnuenvSavedPath}" ] ; then
    exit 0
  fi

  if [ $1 == 0 ] ; then
    gnuenv_bootstrap
  fi

  gnuenvSavedPath="$PATH"
  PATH="/usr/local/opt/sqlite/bin:$PATH"
  PATH="/usr/local/opt/openssl/bin:$PATH"
  PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
  PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
  PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
  PATH="/usr/local/opt/gettext/bin:$PATH"
  PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  PATH="/usr/local/opt/apr-util/bin:$PATH"
  PATH="/usr/local/opt/apr/bin:$PATH"
  export PATH

  gnuenvSavedManpath="$MANPATH"
  MANPATH="/usr/local/opt/readline/share/man:$MANPATH"
  MANPATH="/usr/local/opt/openssl/share/man:$MANPATH"
  MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
  MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"
  MANPATH="/usr/local/opt/gnu-getopt/share/man:$MANPATH"
  MANPATH="/usr/local/opt/gettext/share/man:$MANPATH"
  MANPATH="/usr/local/opt/findutils/libexec/gnuman:$MANPATH"
  MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
  export MANPATH

  gnuenvSavedLDFlags="$LDFLAGS"
  LDFLAGS="-L/usr/local/opt/sqlite/lib"
  LDFLAGS="-L/usr/local/opt/readline/lib $LDFLAGS"
  LDFLAGS="-L/usr/local/opt/openssl/lib $LDFLAGS"
  LDFLAGS="-L/usr/local/opt/libffi/lib $LDFLAGS"
  LDFLAGS="-L/usr/local/opt/icu4c/lib $LDFLAGS"
  LDFLAGS="-L/usr/local/opt/gettext/lib $LDFLAGS"
  export LDFLAGS

  gnuenvSavedCPPFlags="$CPPFLAGS"
  CPPFLAGS="-I/usr/local/opt/sqlite/include"
  CPPFLAGS="-I/usr/local/opt/readline/include $CPPFLAGS"
  CPPFLAGS="-I/usr/local/opt/openssl/include $CPPFLAGS"
  CPPFLAGS="-I/usr/local/opt/icu4c/include $CPPFLAGS"
  CPPFLAGS="-I/usr/local/opt/gettext/include $CPPFLAGS"
  export CPPFLAGS

  gnuenvSavedPkgConfigPath="$PKG_CONFIG_PATH"
  PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"
  PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig:$PKG_CONFIG_PATH"
  PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig:$PKG_CONFIG_PATH"
  PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig:$PKG_CONFIG_PATH"
  export PKG_CONFIG_PATH

  gnuenvSavedPS1="$PS1"
  if [ $2 != 0 ] ; then
    PS1="$3$PS1"
  else
    PS1="(gnuenv) $PS1"
  fi
  export PS1

  # This should detect bash and zsh, which have a hash command that must
  # be called to get it to forget past commands.  Without forgetting
  # past commands the $PATH changes we made may not be respected
  if [ -n "${BASH-}" ] || [ -n "${ZSH_VERSION-}" ] ; then
    hash -r 2>/dev/null
  fi
}

gnuenv_help () {
  # Show the help for gnuenv. Accepts one parameters:
  # $1 (errors) a string containing new line separated errors encountered
  # parsing the command line options.

  version

  echo "$1"

  echo "Enable or disable the GNU environment."
  echo "Option        Notes"
  echo "on            Modify the environment so GNU tools will run,"
  echo "               and change the prompt to indicate this."
  echo "-p --prompt=  Specify alternate string to modify the prompt."
  echo "               Default value is: (gnuenv)"
  echo "-s --skip     Skip bootstraping step (brew upgrade)."
  echo "off           Restore the environment to the prior state."
  echo "--version     Show the version string."
  echo "--help        Show this help that you are reading."
}

gnuenv_version () {
  # Show the version of gnuenv.
  echo "gnuenv 1.0 by Jason Stafford. https://gnuenv.github.io"
}

gnuenv () {
  # Main entry point for gnuenv. Use gnuenv --help to see all the options.

  local command=""
  local error=""
  local promptSet=0
  local promptValue=""
  local skip=0
  local newline="
"
  while [ "$#" -gt 0 ] ; do
    case "$1" in
      on | off | --version | --help)
        if ! [ -z "${command}" ] ; then
          error=${error}"ERROR: ${command} and ${1#--} are mutually exclusive. Use only one or the other."$newline
          command="help"
        else
          command="${1#--}"
        fi
        shift 1
      ;;

      -p)
        promptSet=1
        promptValue="$2"
        shift 2
      ;;
      --prompt=*)
        promptSet=1
        promptValue="${1#*=}"
        shift 1
      ;;
      --prompt)
        error=${error}"ERROR: $1 requires an argument"$newline
        command="help"
        shift 1
      ;;

      -s | --skip)
        skip=0
        shift 1
      ;;

      -e | --easteregg)
        # set the prompt to the water buffalo,
        # closest thing to a GNU in unicode in 2017
        promptSet=1
        promptValue="🐃"
        shift 1
      ;;

      *)
        error=${error}"ERROR: $1 is not a valid option."$newline
        command="help"
        shift 1
      ;;
    esac
  done

  if [ -z "${command}" ] ; then
    command="help"
  fi

  case "$command" in
    on)
      gnuenv_on $skip $promptSet "$promptValue"
    ;;

    off)
      gnuenv_off
    ;;

    help)
      gnuenv_help "$error"
    ;;

    version)
      gnuenv_version
    ;;
  esac

}

# marker for other scripts that might want to check if gnuenv is available.
GNUENV="__GNUENV__"
export GNUENV
