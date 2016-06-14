$archive = "https://ci.appveyor.com/api/buildjobs/i2kibjcahi14gwrp/artifacts/packages-opam.zip"



$arch = "x86"
$inferred_package = "opam"
$version = "1.2"



# Error handling.
$ErrorActionPreference = "Stop"

function CheckExitCode {
    if ($LastExitCode -ne 0) {
        throw "$args exited with $LastExitCode"
    }
}

# Cygwin.
switch ($arch) {
    "x86" {
        $cygwin = "C:\Cygwin"
        $setup = "C:\Cygwin\setup-x86.exe"
        $bash = "C:\Cygwin\bin\bash.exe"
    }
    "x86_64" {
        $cygwin = "C:\Cygwin64"
        $setup = "C:\Cygwin64\setup-x86_64.exe"
        $bash = "C:\Cygwin64\bin\bash.exe"
    }
    default {
        throw "Unknown architecture $arch"
    }
}

function Run($command) {
    echo "+ $command"
    iex $command
}

function Run-Bash {
    $command = "$bash -lc '$args'"
    Run $command
    CheckExitCode $command
}

function Run-CygwinSetup {
    rm $cygwin\var\log\setup*

    $setup_args = @("-W", "-q", "-n") + $args

    echo "+ cmd /c start /wait $setup $setup_args"
    $code = {
        param($setup, $setup_args)
        cmd /c start /wait $setup $setup_args
    }

    if ("-L" -in $args) {
        $timeout = 15
    }
    else {
        $timeout = 30
    }

    $job = Start-Job $code -ArgumentList @($setup, $setup_args)
    if (Wait-Job $job -Timeout $timeout) {
        Receive-Job $job
    }

    if (Get-Process "setup-x86*" -ErrorAction SilentlyContinue) {
        echo "WARNING: Setup is still running after $timeout s"
    }

    Remove-Job $job -Force
    Stop-Process -Name "setup-x86*" -Force
}

# Make sure /etc/skel is copied now, to prevent surprising output that may be
# captured later.
Run-Bash "true"

# Settle on a package name.
if (-not (Test-Path variable:script:package)) {
    $package = $inferred_package
}

# Working directory.
$working_directory = "$env:TEMP\ocaml-binaries"

if (Test-Path $working_directory) {
    rm -recurse $working_directory
}

md $working_directory > $null

# Package installation.
function Install-Package {
    $archive_name = "$working_directory\packages-$package.zip"
    $packages_path = "$working_directory\packages-$package"

    Run "Invoke-WebRequest '$archive' -OutFile '$archive_name'"
    Run "Expand-Archive '$archive_name' '$packages_path'"

    Run-CygwinSetup -L -l $packages_path -P $package
}



# Install aspcud.
$aspcud_archive = "http://downloads.sourceforge.net/project/potassco/aspcud/1.9.1/aspcud-1.9.1-win64.zip"

$aspcud_archive_filename = "$working_directory\aspcud.zip"
$aspcud_archive_filename_cygwin = iex "$bash -lc `"cygpath -au '$aspcud_archive_filename'`""
$aspcud_extracted = "$working_directory\aspcud"
# Use Cygwin wget, because Invoke-WebRequest doesn't seem to follow
# SourceForge's meta refresh.
Run-Bash "wget -O $aspcud_archive_filename_cygwin $aspcud_archive 2>&1"
Run "Expand-Archive '$aspcud_archive_filename' '$aspcud_extracted'"

$aspcud_dest = "$cygwin\bin"
Run "mv '$aspcud_extracted\aspcud-*\*.exe' '$aspcud_dest'"
Run "mv '$aspcud_extracted\aspcud-*\*.lp' '$aspcud_dest'"

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