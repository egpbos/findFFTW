CMake module for finding FFTW 3 using find_package

# Usage

Once added to your project, this module allows you to find FFTW libraries and headers using the CMake `find_package` command:

```cmake
find_package(FFTW [REQUIRED] [QUIET] [COMPONENTS component1 ... componentX] )
```

This module sets the following variables:
- `FFTW_FOUND`                  ... true if fftw is found on the system
- `[component]_LIB_FOUND`  ... true if the component is found on the system (see components below)
- `FFTW_LIBRARIES`              ... full paths to all found fftw libraries
- `[component]_LIB`        ... full path to one of the components (see below)
- `FFTW_INCLUDE_DIRS`           ... fftw include directory paths

The following variables will be checked by the module:
- `FFTW_USE_STATIC_LIBS`        ... if true, only static libraries are found, otherwise both static and shared.
- `FFTW_USE_MKL`                ... if true, use the MKL version of FFTW
- `FFTW_ROOT`                   ... if set, the libraries are exclusively searched under this path.

This package searches for different components depending on if FFTW_USE_MKL is set to true.
For non-MKL, the package search for the following components:
- `FFTW_FLOAT_LIB`
- `FFTW_DOUBLE_LIB`
- `FFTW_LONGDOUBLE_LIB`
- `FFTW_FLOAT_THREADS_LIB`
- `FFTW_DOUBLE_THREADS_LIB`
- `FFTW_LONGDOUBLE_THREADS_LIB`
- `FFTW_FLOAT_OPENMP_LIB`
- `FFTW_DOUBLE_OPENMP_LIB`
- `FFTW_LONGDOUBLE_OPENMP_LIB`

and the following linking targets
- `FFTW::Float`
- `FFTW::Double`
- `FFTW::LongDouble`
- `FFTW::FloatThreads`
- `FFTW::DoubleThreads`
- `FFTW::LongDoubleThreads`
- `FFTW::FloatOpenMP`
- `FFTW::DoubleOpenMP`
- `FFTW::LongDoubleOpenMP`

For MKL, the package searches for the following components:
- `MKL_INTEL_ILP64_LIB` (64-bit OS)
- `MKL_INTEL_C_LIB` (32-bit Windows OS)
- `MKL_INTEL_LIB` (32-bit non-Windows OS)
- `MKL_CORE_LIB`
- `MKL_SEQUENTIAL_LIB`

# Adding to your project

## Automatic download from CMake project

Copy the following into the `CMakeLists.txt` file of the project you want to use FindFFTW in:
```cmake
configure_file(downloadFindFFTW.cmake.in findFFTW-download/CMakeLists.txt)
execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
        RESULT_VARIABLE result
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/findFFTW-download )
if(result)
    message(FATAL_ERROR "CMake step for findFFTW failed: ${result}")
    else()
    message("CMake step for findFFTW completed (${result}).")
endif()
execute_process(COMMAND ${CMAKE_COMMAND} --build .
        RESULT_VARIABLE result
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/findFFTW-download )
if(result)
    message(FATAL_ERROR "Build step for findFFTW failed: ${result}")
endif()

set(findFFTW_DIR ${CMAKE_CURRENT_BINARY_DIR}/findFFTW-src)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${findFFTW_DIR}")
```

And add a file called `downloadFindFFTW.cmake.in` to your project containing the following:
```cmake
cmake_minimum_required(VERSION 2.8.2)

project(findFFTW-download NONE)

include(ExternalProject)

ExternalProject_Add(findFFTW_download
    GIT_REPOSITORY    "https://github.com/egpbos/findfftw.git"
    CONFIGURE_COMMAND ""
    BUILD_COMMAND     ""
    INSTALL_COMMAND   ""
    TEST_COMMAND      ""
    SOURCE_DIR        "${CMAKE_CURRENT_BINARY_DIR}/findFFTW-src"
    BINARY_DIR        ""
    INSTALL_DIR       ""
)
```

After this, `find_package(FFTW)` can be used in the `CMakeLists.txt` file.

## Manual

Clone the repository into directory `PREFIX/findFFTW`:
```sh
git clone https://github.com/egpbos/findfftw.git PREFIX/findFFTW
```

Then add the following to your `CMakeLists.txt` to allow CMake to find the module:
```cmake
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "PREFIX/findFFTW")
```
