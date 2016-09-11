#! /bin/bash



ARCHIVE=https://s3-us-west-2.amazonaws.com/ocaml-binaries/37140cae7c4efae879fa04407d84d1eb579c03c6/opam-1.2.2.pkg
CHECK="opam --version | grep '1\\.2'"



BASENAME=$(basename $ARCHIVE)

set -e
set -x

TEMP_DIRECTORY=$(mktemp -d -t ocaml-binaries)
trap 'rm -rf "$TEMP_DIRECTORY"' EXIT

FILE="$TEMP_DIRECTORY/$BASENAME"

wget -O $FILE $ARCHIVE
sudo installer -pkg $FILE -target /

bash -lc "$CHECK"
