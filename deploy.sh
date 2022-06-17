#!/bin/bash

#
# Shell script for remote deployment and execution of programs.
#
# Usage:
#   ./deploy.sh <source directory> <target> <destination directory> [<command> [<rsync arguments>]]
#
# An example use case is web application development on a Windows host and
#   deployment on a web server.
#
# Another example is embedded development on a Windows host and deployment on
#   remote embedded Linux target (for example BeagleBoard or Raspberry Pi).
#
# Notes:
# - Windows host and Cygwin environment is assumed
# - UNIX target environment with SSH+rsync is assumed
# - SSH public key is expected to be installed on the server
# - SSH agent (for example Pageant) is expected to be running on the host
# - Plink is used instead of OpenSSH as it works with Pageant
# - Targeting use with editors like Sublime Text 3 (tested), SciTE, Notepad++
#

# Source specification (for example "app/")
SRC="$(cygpath -up $1)"
# Target specification (for example "pi@raspberrypi")
TARGET="$2"
# Destination directory (for example "~/app")
DEST="$(cygpath -up $3)"
# Optional command to execute on the target after deployment (for example
#   "~/app/hello.py")
CMD="$4"
# Optional additional rsync arguments (for example "--exclude=.git").
RSYNC_EXTRA="$5"

PLINK='/cygdrive/c/Program Files (x86)/PuTTY/plink.exe'
#DEBUG='-v'


# Transfer
echo "Transferring $SRC to $TARGET:$DEST"

rsync -azr $DEBUG \
    -e "'$PLINK' -batch -C $DEBUG" \
    --delete \
    $RSYNC_EXTRA \
    "$SRC" \
    "$TARGET:$DEST" \

if [ "$?" != "0" ] ; then
    echo
    echo "ERROR: Transfer failed."
    exit 1
fi

# Execute remote command
if [ "$CMD" != "" ] ; then
    echo "Executing: $CMD"
    echo

    "$PLINK" -batch -C $DEBUG "$TARGET" "$CMD"
    if [ "$?" != "0" ] ; then
        echo
        echo "ERROR: Execution failed."
        exit 2
    fi
fi
