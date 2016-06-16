#! /bin/bash

set -e
set -x

wget https://s3-us-west-2.amazonaws.com/ocaml-binaries/37140cae7c4efae879fa04407d84d1eb579c03c6/opam-1.2.2.pkg
sudo installer -pkg opam-1.2.2.pkg -target /

opam --version | grep '1\.2'
