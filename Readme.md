# ghc-llvm-next

A build script (actually a Makefile) and patches to build GHC git HEAD against
the HEAD of LLVM.

* Grabs the HEAD revision of the LLVM tools and builds it.
* Grabs the HEAD revision of GHC.
* Applies patches using the quilt tool.
* Builds the patched GHC using the LLVM tools built in the first step.

## Why

GHC has a LLVM backend and uses the LLVM tools `llc` and `opt`. For some
architectures (Arm and AArch64/Arm64/Armv8-a) the LLVM backend is the primary
backend.

To interoperate with the LVM backend, GHC generates the text version (there is
also a binary format) which seems to change from release to release. Obviously,
waiting for the actual LLVM release to update GHC is non-optimal so I (Erik de
Castro Lopo) decided to set up this project to allow all GHC developers to
keep an eye on upstream LLVM developments that may affect GHC.

## How to use it

Currently this only builds on Linux (patches accepted to fi that). You will also
need the following tool which should be available in most Linux distros:

* ghc (a version that can build git HEAD, currently 7.8)
* gcc and g++ to build LLVM
* GNU make
* quilt
* git

Assuming you have all the tools, after checking out this repo, all you need to
do is:

    make

