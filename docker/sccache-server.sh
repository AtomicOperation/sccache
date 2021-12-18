#!/bin/bash

function cleanup()
{
    pkill sccache-dist
    pkill -f /sccache/
}

trap cleanup EXIT

cleanup

case `uname` in
  Darwin)
    BUILD=mac
    rm -rf ~/Library/Caches/Mozilla.sccache 
    CARGO_TARGET_DIR=target/$BUILD cargo build
    BUILD_ERR=$?
  ;;
  Linux)
    BUILD=linux
    rm -rf /root/.cache/sccache
    CARGO_TARGET_DIR=target/$BUILD cargo build --features="dist-client dist-server"
    BUILD_ERR=$?
  ;;
esac

if [[ $BUILD_ERR != 0 ]]; then
  exit 1
fi

SCCACHE_NO_DAEMON=1 RUST_LOG=warn,sccache=debug,hyper=warn target/linux/debug/sccache-dist scheduler --config docker/scheduler.conf > scheduler.log 2>&1 & 
SCCACHE_NO_DAEMON=1 RUST_LOG=warn,sccache=debug,hyper=warn target/linux/debug/sccache-dist server --config docker/server.conf > server.log 2>&1  &
tail -f server.log #scheduler.log
#read -n 1 -s
#SCCACHE_NO_DAEMON=1 RUST_LOG=trace,sccache=trace,hyper=trace SCCACHE_LOG=trace target/linux/debug/sccache /usr/bin/c++ -o test.o -c test.cpp
