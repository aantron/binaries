#! /bin/bash

# The output of this script should be eval'd. It updates environment variables
# to point to MacPorts.

set -e
set -x

case $(sw_vers -productVersion) in
    10.11*) URL="https://distfiles.macports.org/MacPorts/MacPorts-2.3.4-10.11-ElCapitan.pkg";;
    10.10*) URL="https://distfiles.macports.org/MacPorts/MacPorts-2.3.4-10.10-Yosemite.pkg";;
    10.9*) URL="https://distfiles.macports.org/MacPorts/MacPorts-2.3.4-10.9-Mavericks.pkg";;
    *)
        1>&2 echo "A MacPorts installer for OS X $(sw_vers -productVersion) is not available through this script"
        exit 1;;
esac

1>&2 wget -O macports.pkg "$URL"
1>&2 sudo installer -pkg macports.pkg -target /

export PATH=/opt/local/bin:$PATH

1>&2 sudo port selfupdate

echo 'export PATH=/opt/local/bin:$PATH'
