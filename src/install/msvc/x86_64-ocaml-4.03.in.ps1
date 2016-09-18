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
