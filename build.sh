#!/usr/bin/env bash

# TODO: Make this into a makefile
# Download marmite, run build to output/
curl -Ls https://github.com/rochacbruno/marmite/releases/download/0.2.1/marmite-0.2.1-x86_64-unknown-linux-musl.tar.gz | tar -xz
./marmite source output
# TODO: Fix this in marmite, specifying your own /static prevents all default assets from being placed
rm output/favicon.ico output/static/favicon.ico
touch output/static/favicon.ico