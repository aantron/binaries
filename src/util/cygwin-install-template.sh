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
    >&2 echo "  PREFIX/cygwin/ARCH-PACKAGE-VERSION.ps1.in"
    >&2 echo
    >&2 echo "as argument"
    exit 1
fi

BOILERPLATE=cygwin-install-boilerplate.txt
BOILERPLATE=$(dirname "$0")/$BOILERPLATE
[ -f "$BOILERPLATE" ] || ( >&2 echo "$BOILERPLATE not found" ; exit 1 )

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

cat "$BOILERPLATE"
