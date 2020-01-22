#!/bin/bash

rm -r ./pkg ./src ./*.tar.gz ./*.tar.xz &&
makepkg -rsi
