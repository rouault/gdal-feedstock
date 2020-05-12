
:: Try deleing mingw echo.exe as this seems to cause problems in the build
del %PREFIX%\usr\bin\echo.exe

call "%RECIPE_DIR%\set_bld_opts.bat"

nmake /f makefile.vc %BLD_OPTS%
if errorlevel 1 exit 1

mkdir -p %LIBRARY_PREFIX%\share\doc\gdal
