# bbmp-sources: the source of every part of bbmp's packages

The ByteBandit Music Player ([bbmp](https://github.com/creep-ltx/bbmp)) plays tracker and
chip music with the help of many small programs and libraries written by other people:
UADE, ZXTune, Furnace, AdPlug, libxmp, libopenmpt, sidplayfp and some seventy more. Its
packages (the Flatpak, the AppImage and the macOS package) are built from the exact
versions kept here, so that a build never depends on a website that may change or
disappear, and so that the source of everything in a package can be had in one place.

`SOURCES.md` lists every source: where it comes from, the version, its licence, its
checksum and which part of bbmp uses it.

## What is in here

| File | What it is |
|---|---|
| `archives/` | the sources, one file each |
| `archives/*.local-changes.patch` | the changes bbmp's build scripts make to a source, as a record (the scripts make them by themselves) |
| `SOURCES.md` | the list, one row per source |
| `sources.json` | the same list, for scripts |
| `sha256sums.txt` | the checksum of every file in `archives/` |
| `check.sh` | checks the checksums and that every archive unpacks: `./check.sh` |

Each archive is one of:

- **`<name>-<commit>.tar.xz`**: a git repository at the exact commit, with its submodules,
  without its history and without anything built;
- **an original download** (`.zip`, `.tar.gz`, `.lha`, `.whl`, ...), as it was published;
- **a few repacked archives**: the upstream source with some files taken out, because they
  may not be passed on or because they are songs a build does not need. `SOURCES.md`
  says, in *Changed*, what was taken out of each and why, and `sources.json` keeps the
  checksum of the original. What the player needs of the parts taken out (some Amiga
  players, Atari replay routines, MSX drivers, a sound bank) it downloads from their own
  upstream when the user asks, checked by checksum.

## Building bbmp from this copy

bbmp's build scripts read this folder when `BBMP_SOURCES` names it: each archive is checked
against `sha256sums.txt` and nothing is downloaded.

    git clone https://github.com/creep-ltx/bbmp
    git clone https://github.com/creep-ltx/bbmp-sources
    BBMP_SOURCES=$PWD/bbmp-sources BBMP_SRC=$PWD/work bbmp/tools/build-xmp.sh

The Flatpak is built the same way: `BBMP_SOURCES=$PWD/bbmp-sources
bbmp/packaging/flatpak/make.sh` (see `packaging/flatpak/README.md` in bbmp).

## Licences

Every source here keeps its own licence, stated in its own files; `SOURCES.md` names it.
Nothing in this repository is bbmp's own code.
