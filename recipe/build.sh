#!/bin/bash
# Get an updated config.sub and config.guess
# cp $BUILD_PREFIX/share/gnuconfig/config.* .

set -ex # Abort on error.

# also allow newer symbols (https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk)
export CXXFLAGS="${CXXFLAGS} -std=c++17 -D_LIBCPP_DISABLE_AVAILABILITY"

mkdir build
cd build

# Make sure to disable Arrow/Parquet dependencies for now, so they are only
# used in build_arrow_parquet
cmake -G "Unix Makefiles" \
      ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DBUILD_SHARED_LIBS=ON \
      -DBUILD_TESTING=OFF \
      -DGDAL_USE_PARQUET=OFF \
      -DGDAL_USE_ARROW=OFF \
      -DGDAL_USE_ARROWDATASET=OFF \
      -DGDAL_ENABLE_HDF5_GLOBAL_LOCK:BOOL=ON \
      -DBUILD_PYTHON_BINDINGS:BOOL=OFF \
      -DBUILD_JAVA_BINDINGS:BOOL=OFF \
      -DBUILD_CSHARP_BINDINGS:BOOL=OFF \
      ${SRC_DIR}

cmake --build . -j ${CPU_COUNT} --config Release
