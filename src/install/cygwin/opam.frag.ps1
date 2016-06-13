# Install aspcud.
$aspcud_archive = "http://downloads.sourceforge.net/project/potassco/aspcud/1.9.1/aspcud-1.9.1-win64.zip"

$aspcud_archive_filename = "aspcud.zip"
# Use Cygwin wget, because Invoke-WebRequest doesn't seem to follow
# SourceForge's meta refresh.
$here = & "cygpath" "-au" "."
Run-Bash wget -q -O "/cygdrive/$here/$aspcud_archive_filename" $aspcud_archive
Run "Expand-Archive $aspcud_archive_filename"

$aspcud_dest = "$cygwin\bin"
Run "mv aspcud\aspcud-*\*.exe '$aspcud_dest'"
Run "aspcud\aspcud-*\*.lp '$aspcud_dest'"

# The downloaded aspcud is a native Windows application, and does not understand
# Cygwin paths. Wrap it in a script which treats any argument containing '/' as
# a Cygwin path, and translates it to a Windows path using the cygpath utility.
Run "mv '$aspcud_dest\aspcud.exe' '$aspcud_dest\aspcud-wrapped.exe'"
$aspcud_wrapper = "$cygwin\bin\aspcud"

echo '#! /bin/bash' >> $aspcud_wrapper
echo '' >> $aspcud_wrapper
echo 'CYGPATH=$(which cygpath)' >> $aspcud_wrapper
echo 'ASPCUD=$(which aspcud-wrapped)' >> $aspcud_wrapper
echo '' >> $aspcud_wrapper
echo 'ASPCUD_ARGS=()' >> $aspcud_wrapper
echo '' >> $aspcud_wrapper
echo 'for ARG' >> $aspcud_wrapper
echo 'do' >> $aspcud_wrapper
echo '    if [[ $ARG == */* ]]' >> $aspcud_wrapper
echo '    then' >> $aspcud_wrapper
echo '        PATH=$($CYGPATH -aw "$ARG")' >> $aspcud_wrapper
echo '        ASPCUD_ARGS+=("$PATH")' >> $aspcud_wrapper
echo '    else' >> $aspcud_wrapper
echo '        ASPCUD_ARGS+=("$ARG")' >> $aspcud_wrapper
echo '    fi' >> $aspcud_wrapper
echo 'done' >> $aspcud_wrapper
echo '' >> $aspcud_wrapper
echo '$ASPCUD ${ASPCUD_ARGS[@]}' >> $aspcud_wrapper

Run "dos2unix -q '$aspcud_wrapper'"

Run-Bash chmod +x /bin/aspcud

# Install OPAM.
Install-Package

Run-Bash "opam --version | grep $version"
