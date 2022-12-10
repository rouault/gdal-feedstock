echo %GDAL_DRIVER_PATH%
dir %GDAL_DRIVER_PATH%

ogrinfo --format Arrow
if errorlevel 1 exit 1

ogrinfo --format Parquet
if errorlevel 1 exit 1
