# ghc-llvm-next

A build script (actually a Makefile) and patches to build GHC git HEAD against
the HEAD of LLVM.

* Grabs the HEAD revision of the LLVM tools and builds it.
* Grabs the HEAD revision of GHC.
* Applies patches using the quilt tool.
* Builds the patched GHC using the LLVM tools built in the first step.

## Why

GHC has an LLVM backend and for some architectures (Arm and
AArch64/Arm64/Armv8-a) the LLVM backend is the primary backend. The GHC
developers therefore have a keen interest in tracking between-release changes
in LLVM.

GHC use of LLVM is made somewhat more complicated by the fact that GHC generates
the text version (there is also a binary format) of LLVM Intermediate
Representation (IR) language which it then passes through the LLVM `llc` and
`opt` tools to generate native assembler.

Unfortunately, the LLVM developers do not guaranteed that the IR language will
remain unchanged across major released. It should also be obvious that the GHC
developers should not wait for the actual release of a new LLVM version before
testing it. This project has therefore been set up to make test the development
version of GHC against the development version of LLVM.

## How to use it

Currently this only builds on Linux (patches accepted to fix that). You will also
need the following tool which should be available in most Linux distros:

* ghc (a version that can build git HEAD, currently 7.8)
* The standard build tools needed to build ghc.
* gcc/g++ or clang/clang++ to build LLVM
* quilt
* git

Assuming you have all the tools, after checking out this repo, all you need to
do is:

    make

