mkdir build
if errorlevel 1 exit 1
cd build
if errorlevel 1 exit 1

if  %vc% LEQ 9 set MSVC_VER=1500
if  %vc% GTR 9 set MSVC_VER=1900

if  %vc% LEQ 9 set MSVC_TS_VER=90
if  %vc% GTR 9 set MSVC_TS_VER=140

REM Make sure to disable Arrow/Parquet dependencies for now, so they are only
REM used in build_arrow_parquet

cmake -G "Ninja" ^
      "%CMAKE_ARGS%" ^
      -DMSVC_VERSION="%MSVC_VER%" ^
      -DMSVC_TOOLSET_VERSION="%MSVC_TS_VER%" ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
      -DBUILD_SHARED_LIBS=ON ^
      -DBUILD_TESTING=OFF ^
      -DBUILD_PYTHON_BINDINGS:BOOL=OFF ^
      -DBUILD_JAVA_BINDINGS:BOOL=OFF ^
      -DBUILD_CSHARP_BINDINGS:BOOL=OFF ^
      -DGDAL_USE_KEA:BOOL=ON ^
      -DKEA_INCLUDE_DIR:PATH="%LIBRARY_INC%" ^
      -DKEA_LIBRARY:PATH="%LIBRARY_LIB%\libkea.lib" ^
      -DGDAL_USE_MYSQL:BOOL=OFF ^
      -DGDAL_USE_MSSQL_ODBC:BOOL=OFF ^
      -DGDAL_USE_PARQUET=OFF ^
      -DGDAL_USE_ARROW=OFF ^
      -DGDAL_USE_ARROWDATASET=OFF ^
      "%SRC_DIR%"

if errorlevel 1 exit /b 1

cmake --build . -j %CPU_COUNT% --verbose --config Release
if errorlevel 1 exit /b 1
