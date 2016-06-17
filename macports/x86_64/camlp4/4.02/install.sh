#! /bin/bash



ARCHIVE=https://s3-us-west-2.amazonaws.com/ocaml-binaries/556c27247dbe2b14c9d3d0979eb2d0b9671e7e72/ocaml-camlp4-4.02-7.pkg
CHECK="camlp4 -version | grep '4\\.02'"



BASENAME=$(basename $ARCHIVE)

set -e
set -x

TEMP_DIRECTORY=$(mktemp -d -t ocaml-binaries)
trap 'rm -rf "$TEMP_DIRECTORY"' EXIT

FILE="$TEMP_DIRECTORY/$BASENAME"

wget -O $FILE $ARCHIVE
sudo installer -pkg $FILE -target /

bash -lc "$CHECK"
