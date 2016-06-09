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
        $setup = "C:\Cygwin\setup-x86.exe"
        $bash = "C:\Cygwin\bin\bash.exe"
    }
    "x86_64" {
        $setup = "C:\Cygwin64\setup-x86_64.exe"
        $bash = "C:\Cygwin64\bin\bash.exe"
    }
    default {
        throw "Unknown architecture $arch"
    }
}

# Settle on a package name.
if (-not (Test-Path variable:script:package)) {
    $package = $inferred_package
}

function Install-Package {
    echo "Downloading Cygwin repository with package $package..."

    $archive_name = "packages-$package.zip"
    Invoke-WebRequest $archive -OutFile $archive_name
    Expand-Archive $archive_name

    echo "Installing $package..."

    $packages_path = (Get-Item -Path "packages-$package" -Verbose).FullName
    Start-Process $setup @("-W", "-q", "-L", "-l", $packages_path, "-P", $package) -Wait
    # Not checking the exit code here, as it isn't set.
}
