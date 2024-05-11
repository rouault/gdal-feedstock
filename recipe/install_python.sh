#!/bin/bash

set -xe

# now re-configure with BUILD_PYTHON_BINDINGS:BOOL=ON

cd build

rm -rf swig/python

Python_LOOKUP_VERSION=$($PYTHON -c "import sys; print(str(sys.version_info.major)+'.'+str(sys.version_info.minor)+'.'+str(sys.version_info.micro))")

cmake "-UPython*" \
      -DPython_LOOKUP_VERSION=${Python_LOOKUP_VERSION} \
      -DBUILD_PYTHON_BINDINGS:BOOL=ON \
      -DGDAL_USE_EXTERNAL_LIBS=OFF \
      -DGDAL_BUILD_OPTIONAL_DRIVERS:BOOL=OFF \
      -DOGR_BUILD_OPTIONAL_DRIVERS:BOOL=OFF \
      ${SRC_DIR} || (cat CMakeFiles/CMakeError.log;false)

cmake --build . --target python_generated_files
cd swig/python

$PYTHON setup.py build_ext

$PYTHON -m pip install --no-deps --ignore-installed --no-build-isolation .
