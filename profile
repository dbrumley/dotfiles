# I lump everything into my .profile.  At some point, if it causes
# trouble, I may break things up into .bashrc, etc. 

source /etc/profile

export PATH=~/bin:/opt/local/bin:/opt/local/sbin:$PATH


# OPAM configuration
. /Users/dbrumley/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
export OCAMLPARAM="_,bin-annot=1"
export OPAMKEEPBUILDDIR="yes"
eval `opam config env`


# Recurring compilation directives.
export ARCHFLAGS="-Wno-error=unused-command-line-argument-hard-error-in-future"
export CPATH=/opt/local/include
export LIBRARY_PATH=/opt/local/lib
export BAPCONFIGUREFLAGS="--prefix=`opam config var prefix` --enable-tests"

# Common commands
alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs"
alias es='/Applications/Emacs.app/Contents/MacOS/Emacs --daemon'
alias ec='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c -n'
export EDITOR='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -c'
alias emacs='open -a Emacs.app'
alias lmk='latexmk -pdf -pvc'

# Auto-set the tab-name to the current dir.
# See http://akrabat.com/setting-os-xs-terminal-tab-to-the-current-directory/
function tab_title {
  echo -n -e "\033]0;${PWD##*/}\007"
}
PROMPT_COMMAND="tab_title ; $PROMPT_COMMAND"