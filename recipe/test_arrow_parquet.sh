#!/bin/bash

# exit when any command fails
set -e
# print all commands
set -x

test -f ${PREFIX}/lib/gdalplugins/ogr_Arrow${SHLIB_EXT}
test -f ${PREFIX}/lib/gdalplugins/ogr_Parquet${SHLIB_EXT}

ogrinfo --format Arrow
ogrinfo --format Parquet
