#! /bin/bash



ARCHIVE=https://s3-us-west-2.amazonaws.com/ocaml-binaries/c64689d77d61deabd4a6a1127cb0c773cd102f45/ocaml-4.02.3.pkg
CHECK="ocaml -version | grep '4\\.02'"



BASENAME=$(basename $ARCHIVE)

set -e
set -x

TEMP_DIRECTORY=$(mktemp -d -t ocaml-binaries)
trap 'rm -rf "$TEMP_DIRECTORY"' EXIT

FILE="$TEMP_DIRECTORY/$BASENAME"

wget -O $FILE $ARCHIVE
sudo installer -pkg $FILE -target /

bash -lc "$CHECK"
