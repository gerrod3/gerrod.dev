#!/usr/bin/env bash

# Download marmite, run build to output/
if ! command -v marmite 2>&1 >/dev/null; then
    echo "hello"
    curl -Ls https://github.com/rochacbruno/marmite/releases/download/0.2.3/marmite-0.2.3-x86_64-unknown-linux-musl.tar.gz | tar -xz
    export PATH="$PWD/:$PATH"
fi
marmite source output
