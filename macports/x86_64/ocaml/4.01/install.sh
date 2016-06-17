#! /bin/bash

set -e
set -x

wget https://s3-us-west-2.amazonaws.com/ocaml-binaries/243aee4cc26a8f774156326103ed62d2e915d907/ocaml-4.01.0.pkg
sudo installer -pkg ocaml-4.01.0.pkg -target /

ocaml -version | grep '4\.01'
