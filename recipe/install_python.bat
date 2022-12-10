cd build
if errorlevel 1 exit 1

rd /s /q swig\python

cmake -DPython_EXECUTABLE="%PYTHON%" ^
      -DGDAL_PYTHON_INSTALL_PREFIX:PATH="%STDLIB_DIR%\.." ^
      -DBUILD_PYTHON_BINDINGS:BOOL=ON ^
      -DGDAL_USE_EXTERNAL_LIBS=OFF ^
      -DGDAL_BUILD_OPTIONAL_DRIVERS:BOOL=OFF ^
      -DOGR_BUILD_OPTIONAL_DRIVERS:BOOL=OFF ^
      "%SRC_DIR%"
if errorlevel 1 exit /b 1

cd swig\python
if errorlevel 1 exit /b 1

copy "%SRC_DIR%"\swig\python\osgeo\*.py osgeo
if errorlevel 1 exit /b 1

copy "%SRC_DIR%"\swig\python\extensions\*.c* extensions
if errorlevel 1 exit /b 1

%PYTHON% setup.py install
if errorlevel 1 exit /b 1
