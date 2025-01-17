#!/bin/bash

set -eu

if [ "$TEST_SUBDIR" == "configuration-tests" ]; then
    CAIRO_1_COMPILER_TARGET_TAG=$(jq -r .CAIRO_COMPILER config.json)

    echo "Installing cairo compiler $CAIRO_1_COMPILER_TARGET_TAG"
    # need rust to install cairo-rs-py dependency of devnet
    # need rust to install cairo compiler
    if rustc --version; then
        echo "rustc installed"
    else
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source ~/.cargo/env
    fi

    if [ -z "${CAIRO_1_COMPILER_DIR+x}" ]; then
        # setup cairo1 compiler
        mkdir cairo-compiler
        git clone git@github.com:starkware-libs/cairo.git cairo-compiler \
            --branch $CAIRO_1_COMPILER_TARGET_TAG \
            --single-branch

        cargo build \
            --bin starknet-compile \
            --bin starknet-sierra-compile \
            --manifest-path cairo-compiler/Cargo.toml \
            --release

        export CAIRO_1_COMPILER_DIR=$(realpath "cairo-compiler/target/release")
    fi

    $CAIRO_1_COMPILER_DIR/starknet-compile --version
fi
