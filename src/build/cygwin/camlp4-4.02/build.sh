set -e

# Download and build Camlp4, and package the source and binaries for Cygwin.
cygport ocaml-camlp4.cygport download prep compile install package

# Generate a small Cygwin release tree, including the package.
mkdir -p packages/mirror/$ARCH/release
mv ocaml-camlp4-99-1.*/dist/ocaml-camlp4 packages/mirror/$ARCH/release/
wget -O genini "https://cygwin.com/git/?p=cygwin-apps/genini.git;a=blob_plain;f=genini;hb=HEAD"
cd packages/mirror
perl ../../genini --recursive $ARCH > $ARCH/setup.ini
