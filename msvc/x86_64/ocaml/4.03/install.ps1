$arch = "x86"



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

function Timestamp {
    $now = Get-Date
    $hr = $now.Hour.ToString("00")
    $min = $now.Minute.ToString("00")
    $sec = $now.Second.ToString("00")
    "${hr}:${min}:${sec}"
}

function Run($command) {
    $now = Timestamp
    echo "+ [$now] $command"
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

    $now = Timestamp
    echo "+ [$now] cmd /c start /wait $setup $setup_args"
    $code = {
        param($setup, $setup_args)
        cmd /c start /wait $setup $setup_args
    }

    # See https://github.com/aantron/binaries/commit/6a4c4ec4291de4771a7b08a5d5ef42d7be28c38d.
    if ("-L" -in $args) {
        $timeout = 30
    }
    else {
        $timeout = 60
    }

    # Cygwin64's setup.exe is considerably slower than Cygwin32's.
    if ($arch -eq "x86_64") {
        $timeout = $timeout * 2
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

# Working directory.
$working_directory = "$env:TEMP\ocaml-binaries"

if (Test-Path $working_directory) {
    rm -recurse $working_directory
}

md $working_directory > $null



$archive_remote = "https://github.com/Chris00/ocaml-appveyor/releases/download/0.1/ocaml-4.03.zip"
$archive_local = "$working_directory\ocaml-4.03.zip"

$ocaml_path = "C:\Program Files\OCaml"

Run "Invoke-WebRequest '$archive_remote' -OutFile '$archive_local'"
Run "Expand-Archive '$archive_local' 'C:\Program Files'"

$env:PATH += ";$ocaml_path\bin;$ocaml_path\bin\flexdll"
$env:CAML_LD_LIBRARY_PATH = "$ocaml_path\lib\stublibs"

[System.Environment]::SetEnvironmentVariable(
    "PATH", $env:PATH + ";$ocaml_path\bin;$ocaml_path\bin\flexdll", "Machine")
[System.Environment]::SetEnvironmentVariable(
    "CAML_LD_LIBRARY_PATH", "$ocaml_path\lib\stublibs", "Machine")

Add-Content C:\Cygwin\home\appveyor\.bash_profile 'export PATH="/cygdrive/c/Program Files (x86)/Microsoft Visual Studio 10.0/VC/Bin/amd64":$PATH'
