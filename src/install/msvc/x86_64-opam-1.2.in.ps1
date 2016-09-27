$archive = "https://dl.dropboxusercontent.com/s/b2q2vjau7if1c1b/opam64.tar.xz"
$archive_name = "$working_directory\opam64.tar.xz"

Run-CygwinSetup -P patch -P unzip

Run "Invoke-WebRequest '$archive' -OutFile '$archive_name'"

$working_directory = iex "$bash -lc `"/usr/bin/cygpath -au '$working_directory'`""

Run-Bash "cd $working_directory && tar -xf opam64.tar.xz"
Run-Bash "cd $working_directory && bash opam64/install.sh"

Run-Bash "opam init msvc https://github.com/fdopen/opam-repository-mingw.git -y --auto-setup --verbose 2> /dev/null"

Run-Bash "opam --version"
