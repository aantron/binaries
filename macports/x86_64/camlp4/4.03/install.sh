#! /bin/bash



ARCHIVE=https://s3-us-west-2.amazonaws.com/ocaml-binaries/67d992e78d0235967e76074d8698901056eddf53/ocaml-camlp4-4.03-1.pkg
CHECK="camlp4 -version | grep '4\\.03'"



BASENAME=$(basename $ARCHIVE)

set -e
set -x

TEMP_DIRECTORY=$(mktemp -d -t ocaml-binaries)
trap 'rm -rf "$TEMP_DIRECTORY"' EXIT

FILE="$TEMP_DIRECTORY/$BASENAME"

wget -O $FILE $ARCHIVE
sudo installer -pkg $FILE -target /

bash -lc "$CHECK"
