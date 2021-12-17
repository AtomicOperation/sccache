#!/bin/bash

function cleanup()
{
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
    SCCACHE_DIR="$HOME/src/sccache"

    #CLANG_ARGS="/usr/bin/clang -o test.o -c test.cpp"
    $BUILD_DIR="$HOME/src/sccache"
    CLANG_ARGS="/usr/bin/clang -DAPPBRIDGE_V2 -DRBX_ENABLE_VOICECHAT -DRBX_PLATFORM_MAC -DRBX_PLATFORM_STRING="MacOS" -DRBX_SPEC="studio" -DRBX_STUDIO_BUILD -DRBX_TEST_BUILD -D_SILENCE_CXX17_OLD_ALLOCATOR_MEMBERS_DEPRECATION_WARNING -D__CLANG_SUPPORT_DYN_ANNOTATION__ -I/Users/cswiedler/src/roblox/game-engine/Client/ThirdParty/abseil-cpp -stdlib=libc++ -O3 -DNDEBUG -isysroot /Applications/Xcode11.7.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk -mmacosx-version-min=10.11 -Wrange-loop-analysis -fno-math-errno -Wall -Werror -Wno-unknown-warning-option -Wno-anon-enum-enum-conversion -Wno-unused-but-set-variable -faligned-allocation -DRBX_CONFIG_RELEASE -Os -fvisibility-inlines-hidden -fasm-blocks -fstrict-aliasing -fpascal-strings -fno-common -stdlib=libc++ -g -fvisibility=hidden -Wunguarded-availability -fPIC -fsanitize= -Wextra -Weverything -Wno-c++98-compat-pedantic -Wno-conversion -Wno-covered-switch-default -Wno-deprecated -Wno-disabled-macro-expansion -Wno-double-promotion -Wno-comma -Wno-extra-semi -Wno-extra-semi-stmt -Wno-packed -Wno-padded -Wno-sign-compare -Wno-float-conversion -Wno-float-equal -Wno-format-nonliteral -Wno-gcc-compat -Wno-global-constructors -Wno-exit-time-destructors -Wno-nested-anon-types -Wno-non-modular-include-in-module -Wno-old-style-cast -Wno-range-loop-analysis -Wno-reserved-id-macro -Wno-shorten-64-to-32 -Wno-switch-enum -Wno-thread-safety-negative -Wno-unreachable-code -Wno-unused-macros -Wno-weak-vtables -Wno-zero-as-null-pointer-constant -Wbitfield-enum-conversion -Wbool-conversion -Wconstant-conversion -Wenum-conversion -Wint-conversion -Wliteral-conversion -Wnon-literal-null-conversion -Wnull-conversion -Wobjc-literal-conversion -Wno-sign-conversion -Wstring-conversion -Wno-unreachable-code-return -Wno-missing-noreturn -Wno-shadow -Wno-undef -Wno-tautological-type-limit-compare -Wno-shadow-uncaptured-local -Wno-unused-template -Wno-reserved-identifier -std=c++17 -MD -MT ThirdParty/abseil-cpp/absl/flags/CMakeFiles/absl_flags_usage.dir/usage.cc.o -MF ThirdParty/abseil-cpp/absl/flags/CMakeFiles/absl_flags_usage.dir/usage.cc.o.d -o ThirdParty/abseil-cpp/absl/flags/CMakeFiles/absl_flags_usage.dir/usage.cc.o -c /Users/cswiedler/src/roblox/game-engine/Client/ThirdParty/abseil-cpp/absl/flags/usage.cc"
    BUILD_DIR="$HOME/src/roblox/game-engine/build-studio-tests.ninja/studio-tests/release"
  ;;
  Linux)
    BUILD=linux
    rm -rf /root/.cache/sccache
    CARGO_TARGET_DIR=target/$BUILD cargo build --features="dist-client dist-server"
    BUILD_ERR=$?
    SCCACHE_DIR="/usr/src/sccache"

    CLANG_ARGS="/usr/bin/clang -o test.o -c test.cpp"
    BUILD_DIR="/usr/src/sccache"
  ;;
esac

if [[ $BUILD_ERR != 0 ]]; then
  exit 1
fi

pushd $BUILD_DIR
SCCACHE_NO_DAEMON=1 RUST_LOG=trace,sccache=trace,hyper=trace SCCACHE_LOG=trace $SCCACHE_DIR/target/$BUILD/debug/sccache $CLANG_ARGS 2>&1 | tee $SCCACHE_DIR/client.log
popd
