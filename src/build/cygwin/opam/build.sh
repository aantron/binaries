set -e

# Download and build OPAM, and package the source and binaries for Cygwin.
cygport opam.cygport download prep compile install package

# Generate a small Cygwin release tree, including the package.
mkdir -p packages/mirror/$ARCH/release
mv opam-1.2.2-1.*/dist/opam packages/mirror/$ARCH/release/
wget -O genini "https://cygwin.com/git/?p=cygwin-apps/genini.git;a=blob_plain;f=genini;hb=HEAD"
cd packages/mirror
perl ../../genini --recursive $ARCH > $ARCH/setup.ini
