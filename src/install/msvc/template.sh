set -e

REGEX='.*msvc/([^-]+)-([^-]+)-([^-]+)\.in\.ps1$'

if [[ $1 =~ $REGEX ]]
then
    ARCH=${BASH_REMATCH[1]}
    PACKAGE=${BASH_REMATCH[2]}
    VERSION=${BASH_REMATCH[3]}
else
    >&2 echo "This script expects a path of the form"
    >&2 echo
    >&2 echo "  PREFIX/msvc/ARCH-PACKAGE-VERSION.in.ps1"
    >&2 echo
    >&2 echo "as argument"
    exit 1
fi

echo '$arch' = "\"x86\""

echo
echo
echo

cat src/install/windows_common.frag.ps1

echo
echo
echo

cat $1

if [ "$PACKAGE" = "opam" ]
then
    echo
    echo
    echo

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
fi
