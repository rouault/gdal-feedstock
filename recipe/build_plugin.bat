cd build
if errorlevel 1 exit 1

copy CMakeCache.txt.orig CMakeCache.txt

REM Remove build artifacts potentially generated with a different libarrow version
if "%PKG_NAME%" == "libgdal-arrow-parquet" (
  rmdir ogr\ogrsf_frmts\arrow /s /q
  rmdir ogr\ogrsf_frmts\parquet /s /q
)

for /f "usebackq delims=" %%I in (`powershell "\"%GDAL_PLUGIN_TYPE%\".toUpper()"`) do set "GDAL_PLUGIN_TYPE=%%~I"
for /f "usebackq delims=" %%I in (`powershell "\"%GDAL_PLUGIN_NAME%\".toUpper()"`) do set "GDAL_PLUGIN_NAME=%%~I"

set CMAKE_ARGS=%CMAKE_ARGS% ^
      -DOGR_REGISTER_DRIVER_ARROW_FOR_LATER_PLUGIN=OFF ^
      -DOGR_REGISTER_DRIVER_PARQUET_FOR_LATER_PLUGIN=OFF ^
      -DGDAL_REGISTER_DRIVER_JP2OPENJPEG_FOR_LATER_PLUGIN=OFF ^
      -DGDAL_REGISTER_DRIVER_PDF_FOR_LATER_PLUGIN=OFF ^
      -DGDAL_REGISTER_DRIVER_POSTGISRASTER_FOR_LATER_PLUGIN=OFF ^
      -DOGR_REGISTER_DRIVER_PG_FOR_LATER_PLUGIN=OFF ^
      -DGDAL_REGISTER_DRIVER_FITS_FOR_LATER_PLUGIN=OFF ^
      -DOGR_REGISTER_DRIVER_XLS_FOR_LATER_PLUGIN=OFF ^
      -DGDAL_REGISTER_DRIVER_GRIB_FOR_LATER_PLUGIN=OFF ^
      -DGDAL_REGISTER_DRIVER_KEA_FOR_LATER_PLUGIN=OFF ^


if "%PKG_NAME%" == "libgdal-arrow-parquet" (
  set CMAKE_ARGS=%CMAKE_ARGS% ^
      -DGDAL_USE_PARQUET=ON ^
      -DGDAL_USE_ARROW=ON ^
      -DGDAL_USE_ARROWDATASET=ON ^
      -DOGR_ENABLE_DRIVER_ARROW=ON ^
      -DOGR_ENABLE_DRIVER_ARROW_PLUGIN=ON ^
      -DOGR_ENABLE_DRIVER_PARQUET=ON ^
      -DOGR_ENABLE_DRIVER_PARQUET_PLUGIN=ON
) else (
  set CMAKE_ARGS=%CMAKE_ARGS% %GDAL_PLUGIN_DEPS% ^
      -D%GDAL_PLUGIN_TYPE%_ENABLE_DRIVER_%GDAL_PLUGIN_NAME%=ON ^
      -D%GDAL_PLUGIN_TYPE%_ENABLE_DRIVER_%GDAL_PLUGIN_NAME%_PLUGIN=ON
)


REM We reuse the same build directory as libgdal, so we just to have to
REM turn on the required dependency and drivers
cmake -DBUILD_PYTHON_BINDINGS:BOOL=OFF %CMAKE_ARGS% "%SRC_DIR%"
if errorlevel 1 exit /b 1

cmake --build . -j %CPU_COUNT% --verbose --config Release
if errorlevel 1 exit /b 1

cmake --build . --target install --config Release
if errorlevel 1 exit /b 1
