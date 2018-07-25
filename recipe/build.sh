#!/bin/bash

export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"

# Filter out -std=.* from CXXFLAGS as it disrupts checks for C++ language levels.
re='(.*[[:space:]])\-std\=[^[:space:]]*(.*)'
if [[ "${CXXFLAGS}" =~ $re ]]; then
    export CXXFLAGS="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
fi

pushd swig/python

$PYTHON setup.py build_ext \
    --include-dirs $INCLUDE_PATH \
    --library-dirs $LIBRARY_PATH \
    --gdal-config gdal-config
$PYTHON setup.py build_py
$PYTHON setup.py build_scripts
$PYTHON setup.py install

popd
