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
    $setup_args = @("-W", "-q") + $args
    Run "cmd /c start /wait $setup $setup_args"
    # Not checking the exit code here, as it isn't always set.
}

# Settle on a package name.
if (-not (Test-Path variable:script:package)) {
    $package = $inferred_package
}

function Install-Package {
    $archive_name = "packages-$package.zip"
    Run "Invoke-WebRequest '$archive' -OutFile $archive_name"
    Run "Expand-Archive $archive_name"

    $packages_path = (Get-Item -Path "packages-$package" -Verbose).FullName
    Run-CygwinSetup -L -l $packages_path -P $package
}
