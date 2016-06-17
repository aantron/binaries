set -e

REGEX='.*macports/([^-]+)-([^-]+)-([^-]+)\.in\.sh$'

if [[ $1 =~ $REGEX ]]
then
    ARCH=${BASH_REMATCH[1]}
    PACKAGE=${BASH_REMATCH[2]}
    VERSION=${BASH_REMATCH[3]}
else
    >&2 echo "This script expects a path of the form"
    >&2 echo
    >&2 echo "  PREFIX/macports/ARCH-PACKAGE-VERSION.in.sh"
    >&2 echo
    >&2 echo "as argument"
    exit 1
fi

echo "#! /bin/bash"

echo
echo
echo

cat $1

echo
echo
echo

cat src/install/macports/common.frag.sh
