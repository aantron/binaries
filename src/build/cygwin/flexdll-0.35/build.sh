set -e
set -x

# Download and build FlexDLL, and package the source and binaries for Cygwin.
# The .cygport file also applies any needed patches.
cygport flexdll.cygport download prep compile install package

# Generate a small Cygwin release tree, including the package.
mkdir -p packages/mirror/$ARCH/release
mv flexdll-0.35-1.*/dist/flexdll packages/mirror/$ARCH/release/

# Generate setup.ini using genini.
wget -O genini "https://cygwin.com/git/?p=cygwin-apps/genini.git;a=blob_plain;f=genini;hb=HEAD"
cd packages/mirror

# cygport now appears to name setup.hint after the package name, but genini
# still expects setup.hint.
mv $ARCH/release/flexdll/flexdll-0.35-1.hint $ARCH/release/flexdll/setup.hint

perl ../../genini --recursive $ARCH > $ARCH/setup.ini

# Make sure setup.ini has the flexdll package.
grep '^@ flexdll' $ARCH/setup.ini
