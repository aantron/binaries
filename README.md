# OCaml Binaries

*Unreleased*

This repository builds OCaml binaries for every platform, hosts them, and wraps
them in nice installation scripts that you can drop into your `.travis.yml` or
`appveyor.yml` build matrix:

```sh
# Travis
wget -q -O - https://aantron.github.io/binaries/macports/x86_64/ocaml/4.03/install.sh | bash

# AppVeyor
ps: '(new-object net.webclient).DownloadString("https://aantron.github.io/binaries/mingw/x86_64/ocaml/4.03/install.ps1") | PowerShell -Command -'
```

As you can see, the URLs follow a simple pattern:

```
https://aantron.github.io/binaries/$SYSTEM/$ARCH/$PACKAGE/$VERSION/install.(sh|ps1)
```

The purpose is twofold:
- Speed up CI and not waste resources by rebuilding the OCaml
  compiler, OPAM, or related binaries. A typical build row is sped up by a
  factor of two or more.
- Encourage authors to test on diverse platforms by making it easier to do so.

Packages include OCaml, Camlp4, OPAM, and FlexDLL. For now, not everything is
available for every system due to time constraints; you can browse the available
scripts [here](https://github.com/aantron/binaries/tree/gh-pages).

The scripts are in use in CI for [Lwt][lwt] and [OASIS][oasis-appveyor].

## Plan

1. MSVC scripts are nearly done, but I am not planning to work on this for about
   a month.
2. After that, it should be easy to wrap the existing PPAs for Ubuntu OCaml
   4.01, 4.02, and provide installers for newer versions. Homebrew should also
   be easy.

## Other

I hope that this repository can become a reference for how to package OCaml for
the various system package managers out there (Cygwin, MacPorts, Homebrew,
etc.). Then, we can better keep OCaml packages up to date everywhere. For
example, Cygwin has been left behind at 4.02.3, and MacPorts has 4.02.2.

Perhaps, eventually, we can make regular distribution packages here as well, not
just packages for speeding up CI builds.

Making sure OCaml builds on the platforms results in improvements to the
upstream.

## Acknowledgements

The MinGW scripts are wrapping [opam-repository-mingw][opam-repo-mingw],
maintained by fdopen.

The MSVC work-in-progress script is wrapping Chris00's
[ocaml-appveyor][ocaml-appveyor].

[lwt]: https://github.com/ocsigen/lwt
[oasis-appveyor]: https://github.com/ocaml/oasis/blob/master/appveyor.yml
[opam-repo-mingw]: https://fdopen.github.io/opam-repository-mingw/
[ocaml-appveyor]: https://github.com/Chris00/ocaml-appveyor
