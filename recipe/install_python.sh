#!/bin/bash

set -xe

# now re-configure with BUILD_PYTHON_BINDINGS:BOOL=ON

cd build

rm -rf swig/python

cmake -DPython_EXECUTABLE="$PYTHON" \
      -DBUILD_PYTHON_BINDINGS:BOOL=ON \
      -DGDAL_USE_EXTERNAL_LIBS=OFF \
      -DGDAL_BUILD_OPTIONAL_DRIVERS:BOOL=OFF \
      -DOGR_BUILD_OPTIONAL_DRIVERS:BOOL=OFF \
      ${SRC_DIR} || (cat CMakeFiles/CMakeError.log;false)

cmake --build . --target python_generated_files
cd swig/python

cat >pyproject.toml <<EOF
[build-system]
requires = ["setuptools>=40.8.0", "wheel"]
build-backend = "setuptools.build_meta"
EOF

$PYTHON setup.py build_ext

$PYTHON -m pip install --no-deps --ignore-installed .
