set -e

REGEX='.*cygwin/([^-]+)-([^-]+)-([^-]+)\.in\.ps1$'

if [[ $1 =~ $REGEX ]]
then
    ARCH=${BASH_REMATCH[1]}
    PACKAGE=${BASH_REMATCH[2]}
    VERSION=${BASH_REMATCH[3]}
else
    >&2 echo "This script expects a path of the form"
    >&2 echo
    >&2 echo "  PREFIX/cygwin/ARCH-PACKAGE-VERSION.in.ps1"
    >&2 echo
    >&2 echo "as argument"
    exit 1
fi

cat $1

echo
echo
echo

echo '$arch' = "\"$ARCH\""
echo '$inferred_package' = "\"$PACKAGE\""
echo '$version' = "\"$VERSION\""

echo
echo
echo

cat src/install/cygwin/common.frag.ps1

echo
echo
echo

PACKAGE_SCRIPT=src/install/cygwin/$PACKAGE.frag.ps1
cat $PACKAGE_SCRIPT
