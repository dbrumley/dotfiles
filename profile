# I lump everything into my .profile.  At some point, if it causes
# trouble, I may break things up into .bashrc, etc. 

source /etc/profile

export PATH=~/bin:/opt/local/bin:/opt/local/sbin:/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin:$PATH


# OPAM configuration
. /Users/dbrumley/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
export OCAMLPARAM="_,bin-annot=1"
export OPAMKEEPBUILDDIR="yes"
. /Users/dbrumley/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
eval `opam config env`


# Recurring compilation directives.
export ARCHFLAGS="-Wno-error=unused-command-line-argument-hard-error-in-future"
export CPATH=/opt/local/include
export LIBRARY_PATH=/opt/local/lib
export BAPCONFIGUREFLAGS="--prefix=`opam config var prefix` --enable-tests"

# Common commands
export MYEMACSDIR="/Applications/Emacs.app/Contents/MacOS"
alias es="${MYEMACSDIR}/Emacs --daemon"
alias ec="${MYEMACSDIR}/bin/emacsclient -c -n"
alias ecr="${MYEMACSDIR}/bin/emacsclient -c -n -r"
alias emacs="${MYEMACSDIR}/Emacs"
alias emacsr="${MYEMACSDIR}/Emacs -r"

#alias es='/Applications/Emacs.app/Contents/MacOS/Emacs --daemon'
#alias ec='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c -n'
#export EDITOR='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c'
#alias emacs='open -a Emacs.app --args -r'
#alias emacs="/Applications/MacPorts/EmacsMac.app/Contents/MacOS/Emacs -r"
#alias es="/Applications/MacPorts/EmacsMac.app/Contents/MacOS/Emacs --daemon"
#alias ec="/Applications/MacPorts/EmacsMac.app/Contents/MacOS/bin/emacsclient -c"
#alias emacsr="/Applications/MacPorts/EmacsMac.app/Contents/MacOS/Emacs -r"
#alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs -r"
alias lmk='latexmk -pdf -pvc'

# Auto-set the tab-name to the current dir.
# See http://akrabat.com/setting-os-xs-terminal-tab-to-the-current-directory/
function tab_title {
  echo -n -e "\033]0;${PWD##*/}\007"
}
PROMPT_COMMAND="tab_title ; $PROMPT_COMMAND"

# Make bash have colors for directories
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx


# MacPorts Installer addition on 2015-04-05_at_11:27:40: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# I install with pip using --user; this is the default bin dir for 
# the resulting files.
export PATH=/Users/dbrumley/Library/Python/2.7/bin/:$PATH

# Make `pip install` install with --user by default
pip() {
  if [ "$1" = "install" -o "$1" = "bundle" ]; then
    cmd="$1"
    shift
    /opt/local/bin/pip $cmd --user $@
  else
    /opt/local/bin/pip $@
  fi
}
