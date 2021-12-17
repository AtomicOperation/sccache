#!/bin/sh
bwrap \
	--ro-bind / / \
	--bind /usr/src/sccache/store/build/toolchains/osx / \
	--proc /proc \
	--dev /dev \
	/bin/o64-clang++ -x c++-cpp-output -c /test.cpp -o /test.o
