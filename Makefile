
top_dir = $(shell pwd)
cpus = $(shell grep ^processor /proc/cpuinfo | wc -l)



all : stamp/ghc-test


update : llvm-src/CMakeLists.txt ghc-src/configure.ac
	make clean
	make stamp/llvm-update stamp/ghc-update


clean :
	(cd ghc-src && make clean)
	rm -rf llvm-build/*
	rm -f stamp/*

git-gc :
	(cd ghc-src/ && git gc --aggressive)
	(cd llvm-src/ && git gc --aggressive)

#-------------------------------------------------------------------------------
# GHC

stamp/ghc-test : stamp/ghc-build
	(cd ghc-src && SKIP_PERF_TESTS=YES THREADS=$(cpus) make test)
	touch $@

stamp/ghc-build : stamp/ghc-configure
	(cd ghc-src && make -j$(cpus))
	touch $@

stamp/ghc-configure : stamp/ghc-update stamp/llvm-install
	sed s'/#BuildFlavour = quick-llvm/BuildFlavour = quick-llvm/' ghc-src/mk/build.mk.sample > ghc-src/mk/build.mk
	(cd ghc-src && perl boot && ./configure \
			--with-llc=$(top_dir)/llvm-install/bin/llc \
			--with-opt=$(top_dir)/llvm-install/bin/opt )
	touch $@

stamp/ghc-update : ghc-src/configure.ac
	if test $(shell quilt applied | grep -c ^patches/) -ge 1 ; then \
		quilt pop -a ; \
		fi
	(cd ghc-src && git reset --hard origin/master && \
		git pull && git submodule update --init --recursive --rebase)
	quilt push -a
	touch $@

ghc-src/configure.ac :
	mkdir -p stamp
	git clone git://git.haskell.org/ghc.git ghc-src
	(cd ghc-src && git submodule update --init --recursive --rebase)

#-------------------------------------------------------------------------------
# LLVM

stamp/llvm-install : stamp/llvm-build
	(cd llvm-build && make install)
	touch $@

stamp/llvm-build : stamp/llvm-configure
	(cd llvm-build && make -j$(cpus))
	touch $@

stamp/llvm-configure : stamp/llvm-update
	mkdir -p llvm-build
	(cd llvm-build && ../llvm-src/configure --prefix=$(top_dir)/llvm-install)
	touch $@

stamp/llvm-update : llvm-src/CMakeLists.txt
	(cd llvm-src && git pull --rebase)
	rm -f stamp/llvm-*
	touch $@

llvm-src/CMakeLists.txt :
	mkdir -p stamp
	git clone http://llvm.org/git/llvm.git llvm-src
