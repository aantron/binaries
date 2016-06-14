$archive = "https://ci.appveyor.com/api/buildjobs/k3qrn23xsqt9rkep/artifacts/packages-ocaml-camlp4.zip"
$package = "ocaml-camlp4"



$arch = "x86"
$inferred_package = "camlp4"
$version = "4.02"



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

    # See https://github.com/aantron/binaries/commit/6a4c4ec4291de4771a7b08a5d5ef42d7be28c38d.
    if ("-L" -in $args) {
        $timeout = 15
    }
    else {
        $timeout = 30
    }

    # Cygwin64's setup.exe is considerably slower than Cygwin32's.
    if ($arch -eq "x86_64") {
        $timeout = $timeout + 15
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



echo "Camlp4: checking for compatible OCaml version"
Run-Bash "ocaml -version | grep $version"

Install-Package

Run-Bash "camlp4o -version | grep $version"