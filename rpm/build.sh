#!/bin/bash

rm -f libuvc-*.tar.gz
ln ../libuvc-*.tar.gz .
rel=`cut -d' ' -f3 < /etc/redhat-release`
fedpkg --release f$rel local
