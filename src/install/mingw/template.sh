set -e

REGEX='.*mingw/([^-]+)-([^-]+)-([^-]+)\.in\.ps1$'

if [[ $1 =~ $REGEX ]]
then
    ARCH=${BASH_REMATCH[1]}
    PACKAGE=${BASH_REMATCH[2]}
    VERSION=${BASH_REMATCH[3]}
else
    >&2 echo "This script expects a path of the form"
    >&2 echo
    >&2 echo "  PREFIX/mingw/ARCH-PACKAGE-VERSION.in.ps1"
    >&2 echo
    >&2 echo "as argument"
    exit 1
fi

echo '$arch' = "\"$ARCH\""
echo '$package' = "\"dummy\""

echo
echo
echo

cat src/install/cygwin/common.frag.ps1

echo
echo
echo

cat $1
