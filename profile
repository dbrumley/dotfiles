# I lump everything into my .profile.  At some point, if it causes
# trouble, I may break things up into .bashrc, etc. 

source /etc/profile



######################
# Set up Emacs Alias #
######################

#export MYEMACSDIR="/Applications/Emacs.app/Contents/MacOS"
#export MYEMACSDIR="/Applications/MacPorts/EmacsMac.app/Contents/MacOS"
#alias es="${MYEMACSDIR}/Emacs -r --daemon"
export MYEMACSDIR="/usr/local"

# Run emacs client.
#  -c open a new window
#  -n don't want for the window to be closed (e.g., run in background)
#  -a "" If you don't find a server, start one.  I've never got this
#        to work on my mac for some reason.
#  -r Run in reverse
#  $* The options passed in.

alias ec="${MYEMACSDIR}/bin/emacsclient -c -n $*"
alias ecr="${MYEMACSDIR}/bin/emacsclient -c -n -r $*"
alias emacs="${MYEMACSDIR}/bin/emacs"
alias emacsr="${MYEMACSDIR}/bin/emacs -r"
export EDITOR="${MYEMACSDIR}/bin/emacsclient -c  $*"

#############################################
# Auto-set the tab-name to the current dir. #
#############################################

# See http://akrabat.com/setting-os-xs-terminal-tab-to-the-current-directory/
function tab_title {
  echo -n -e "\033]0;${PWD##*/}\007"
}
PROMPT_COMMAND="tab_title ; $PROMPT_COMMAND"

# Make bash have colors for directories
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx


######################
# Brew configuration #
######################

# Set architecture flags
export ARCHFLAGS="-arch x86_64"
# Ensure user-installed binaries take precedence
export PATH=/usr/local/bin:$PATH
# Load .bashrc if it exists
test -f ~/.bashrc && source ~/.bashrc


#####################
# IDA configuration #
#####################
export PATH=${PATH}:/Applications/IDA\ Pro\ 6.95/idabin
. /Users/dbrumley/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true


######################
# OPAM configuration #
######################
export OCAMLPARAM="_,bin-annot=1"
export OPAMKEEPBUILDDIR="yes"
. /Users/dbrumley/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
eval `opam config env`
