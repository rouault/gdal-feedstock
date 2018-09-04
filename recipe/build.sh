#!/bin/bash

pushd swig/python

$PYTHON setup.py build_ext \
    --include-dirs $INCLUDE_PATH \
    --library-dirs $LIBRARY_PATH \
    --gdal-config gdal-config
$PYTHON setup.py build_py
$PYTHON setup.py build_scripts
$PYTHON setup.py install

popd

# We can remove this when we start using the new conda-build.
find $PREFIX -name '*.la' -delete
