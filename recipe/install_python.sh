#!/bin/bash

set -xe

# now re-configure with BUILD_PYTHON_BINDINGS:BOOL=ON

cd build

rm -rf swig/python

cmake -DPython_EXECUTABLE="$PYTHON" \
      -DBUILD_PYTHON_BINDINGS:BOOL=ON \
      ${SRC_DIR} || (cat CMakeFiles/CMakeError.log;false)

cd swig/python
cp ${SRC_DIR}/swig/python/osgeo/*.py osgeo/
cp ${SRC_DIR}/swig/python/extensions/*.c* extensions/

cat >pyproject.toml <<EOF
[build-system]
requires = ["setuptools>=40.8.0", "wheel"]
build-backend = "setuptools.build_meta"
EOF

$PYTHON setup.py build_ext
$PYTHON -m pip install --no-deps --ignore-installed .
