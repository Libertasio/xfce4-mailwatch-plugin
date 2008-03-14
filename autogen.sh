#!/bin/sh
#
# $Id: autogen.sh 13265 2005-03-12 04:15:08Z brian $
#
# Copyright (c) 2002-2005
#         The Xfce development team. All rights reserved.
#
# Written for Xfce by Benedikt Meurer <benny@xfce.org>.
#

(type xdt-autogen) >/dev/null 2>&1 || {
  cat >&2 <<EOF
autogen.sh: You don't seem to have the Xfce development tools installed on
            your system, which are required to build this software.
            Please install the xfce4-dev-tools package first, it is available
            from http://www.xfce.org/.
EOF
  exit 1
}

(test -f po/LINGUAS) >/dev/null 2>&1 || {
  cat >&2 <<EOF
autogen.sh: The file po/LINGUAS could not be found. Please check your snapshot
            or try to check out again.
EOF
  exit 1
}

echo 'dnl *** This file is autogenerated.  Do not edit. ***' >configure.ac
echo >>configure.ac

linguas=$(sed -e '/^#/d' po/LINGUAS)

if [ -d .git/svn ]; then
    revision=$(git-svn find-rev trunk)
elif [ -d .svn ]; then
    revision=$(LC_ALL=C svn info $0 | awk '/^Revision: /{ printf "%05d", $2 }')
else
    revision=UNKNOWN
fi

sed -e "s/@LINGUAS@/${linguas}/g" \
    -e "s/@REVISION@/${revision}/g" \
    < "configure.ac.in" >> "configure.ac"

exec xdt-autogen $@

# vi:set ts=2 sw=2 et ai:
