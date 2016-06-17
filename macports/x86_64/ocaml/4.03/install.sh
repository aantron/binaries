#! /bin/bash



ARCHIVE=https://s3-us-west-2.amazonaws.com/ocaml-binaries/07d4aa3a0afc331387785fc785c53c0e0f8de1d1/ocaml-4.03.0.pkg
CHECK="ocaml -version | grep '4\\.03'"



BASENAME=$(basename $ARCHIVE)

set -e
set -x

TEMP_DIRECTORY=$(mktemp -d -t ocaml-binaries)
trap 'rm -rf "$TEMP_DIRECTORY"' EXIT

FILE="$TEMP_DIRECTORY/$BASENAME"

wget -O $FILE $ARCHIVE
sudo installer -pkg $FILE -target /

bash -lc "$CHECK"
