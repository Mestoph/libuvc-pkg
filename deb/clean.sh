#!/bin/bash

version=`cat version`

rm -fr libuvc-$version
rm -fr libuvc_*
rm -fr libuvc-dev_*
rm -fr libuvc-dbgsym_*
rm -f debfiles/compat
