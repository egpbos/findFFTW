# - Find the FFTW library
#
# Original version of this file:
#   Copyright (c) 2015, Wenzel Jakob (under BSD 2-clause license, see LICENSE.txt file in this directory)
#   https://github.com/wjakob/layerlab/blob/master/cmake/FindFFTW.cmake, commit 4d58bfdc28891b4f9373dfe46239dda5a0b561c6
# Modifications:
#   Copyright (c) 2017, Patrick Bos (under BSD 3-clause license, see LICENSE file distributed with this software)
#   MKL code adapted from:
#   https://github.com/InsightSoftwareConsortium/ITK/blob/master/CMake/FindFFTW.cmake, commit 8898b7f622c14f828a807a2ccb2fb9217538dc07
#
# Usage:
#   find_package(FFTW [REQUIRED] [QUIET] [COMPONENTS component1 ... componentX] )
#
# It sets the following variables:
#   FFTW_FOUND                  ... true if fftw is found on the system
#   [component]_LIB_FOUND       ... true if the component is found on the system (see components below)
#   FFTW_LIBRARIES              ... full paths to all found fftw libraries
#   [component]_LIB             ... full path to one of the components (see below)
#   FFTW_INCLUDE_DIRS           ... fftw include directory paths
#
# The following variables will be checked by the function
#   FFTW_USE_STATIC_LIBS        ... if true, only static libraries are found, otherwise both static and shared.
#   FFTW_USE_MKL                ... if true, use the MKL version of FFTW
#   FFTW_ROOT                   ... if set, the libraries are exclusively searched
#                                   under this path
#
# Components:
# This package searches for different components depending on if FFTW_USE_MKL is set to true. For non-MKL,
# the package search for the following components:
#   FFTW_FLOAT_LIB
#   FFTW_DOUBLE_LIB
#   FFTW_LONGDOUBLE_LIB
#   FFTW_FLOAT_THREADS_LIB
#   FFTW_DOUBLE_THREADS_LIB
#   FFTW_LONGDOUBLE_THREADS_LIB
#   FFTW_FLOAT_OPENMP_LIB
#   FFTW_DOUBLE_OPENMP_LIB
#   FFTW_LONGDOUBLE_OPENMP_LIB
#
# For MKL, the package searches for the following components:
#   MKL_INTEL_ILP64_LIB (64-bit OS)
#   MKL_INTEL_C_LIB (32-bit Windows OS)
#   MKL_INTEL_LIB (32-bit non-Windows OS)
#   MKL_CORE_LIB
#   MKL_SEQUENTIAL_LIB
#

# TODO (maybe): extend with ExternalProject download + build option
# TODO: turn into independent project on github (perhaps also on conda so it can be used as dependency for xtensor-fftw)

# If environment variable FFTWDIR or MKLROOT is specified, it has same effect as FFTW_ROOT
if( NOT FFTW_ROOT AND NOT FFTW_USE_MKL AND ENV{FFTWDIR} )
  set( FFTW_ROOT $ENV{FFTWDIR} )
endif()

# Check if we can use PkgConfig
find_package(PkgConfig)

#Determine from PKG
if( PKG_CONFIG_FOUND AND NOT FFTW_ROOT )
  pkg_check_modules( PKG_FFTW QUIET "fftw3" )
endif()

#Check whether to search static or dynamic libs
set( CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES} )

if( ${FFTW_USE_STATIC_LIBS} )
  set( CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX} )
else()
  set( CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV} )
endif()

# Find Libraries :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if( FFTW_ROOT AND NOT FFTW_USE_MKL )

  # Find standard FFTW libs in FFTW_ROOT .......................................
  find_library(
    FFTW_DOUBLE_LIB
    NAMES "fftw3" libfftw3-3
    PATHS ${FFTW_ROOT}
    PATH_SUFFIXES "lib" "lib64"
    NO_DEFAULT_PATH
  )

  find_library(
    FFTW_DOUBLE_THREADS_LIB
    NAMES "fftw3_threads"
    PATHS ${FFTW_ROOT}
    PATH_SUFFIXES "lib" "lib64"
    NO_DEFAULT_PATH
  )

  find_library(
          FFTW_DOUBLE_OPENMP_LIB
          NAMES "fftw3_omp"
          PATHS ${FFTW_ROOT}
          PATH_SUFFIXES "lib" "lib64"
          NO_DEFAULT_PATH
  )

  find_library(
    FFTW_FLOAT_LIB
    NAMES "fftw3f" libfftw3f-3
    PATHS ${FFTW_ROOT}
    PATH_SUFFIXES "lib" "lib64"
    NO_DEFAULT_PATH
  )

  find_library(
    FFTW_FLOAT_THREADS_LIB
    NAMES "fftw3f_threads"
    PATHS ${FFTW_ROOT}
    PATH_SUFFIXES "lib" "lib64"
    NO_DEFAULT_PATH
  )

  find_library(
          FFTW_FLOAT_OPENMP_LIB
          NAMES "fftw3f_omp"
          PATHS ${FFTW_ROOT}
          PATH_SUFFIXES "lib" "lib64"
          NO_DEFAULT_PATH
  )

  find_library(
    FFTW_LONGDOUBLE_LIB
    NAMES "fftw3l" libfftw3l-3
    PATHS ${FFTW_ROOT}
    PATH_SUFFIXES "lib" "lib64"
    NO_DEFAULT_PATH
  )

  find_library(
    FFTW_LONGDOUBLE_THREADS_LIB
    NAMES "fftw3l_threads"
    PATHS ${FFTW_ROOT}
    PATH_SUFFIXES "lib" "lib64"
    NO_DEFAULT_PATH
  )

  find_library(
          FFTW_LONGDOUBLE_OPENMP_LIB
          NAMES "fftw3l_omp"
          PATHS ${FFTW_ROOT}
          PATH_SUFFIXES "lib" "lib64"
          NO_DEFAULT_PATH
  )

  #find includes
  find_path(FFTW_INCLUDE_DIRS
    NAMES "fftw3.h"
    PATHS ${FFTW_ROOT}
    PATH_SUFFIXES "include"
    NO_DEFAULT_PATH
  )

endif()

# Find standard FFTW libs in standard locations ................................
if (NOT FFTW_ROOT)

  find_library(
    FFTW_DOUBLE_LIB
    NAMES "fftw3"
    PATHS ${PKG_FFTW_LIBRARY_DIRS} ${LIB_INSTALL_DIR}
  )

  find_library(
    FFTW_DOUBLE_THREADS_LIB
    NAMES "fftw3_threads"
    PATHS ${PKG_FFTW_LIBRARY_DIRS} ${LIB_INSTALL_DIR}
  )

  find_library(
          FFTW_DOUBLE_OPENMP_LIB
          NAMES "fftw3_omp"
          PATHS ${PKG_FFTW_LIBRARY_DIRS} ${LIB_INSTALL_DIR}
  )

  find_library(
    FFTW_FLOAT_LIB
    NAMES "fftw3f"
    PATHS ${PKG_FFTW_LIBRARY_DIRS} ${LIB_INSTALL_DIR}
  )

  find_library(
    FFTW_FLOAT_THREADS_LIB
    NAMES "fftw3f_threads"
    PATHS ${PKG_FFTW_LIBRARY_DIRS} ${LIB_INSTALL_DIR}
  )

  find_library(
          FFTW_FLOAT_OPENMP_LIB
          NAMES "fftw3f_omp"
          PATHS ${PKG_FFTW_LIBRARY_DIRS} ${LIB_INSTALL_DIR}
  )

  find_library(
    FFTW_LONGDOUBLE_LIB
    NAMES "fftw3l"
    PATHS ${PKG_FFTW_LIBRARY_DIRS} ${LIB_INSTALL_DIR}
  )

  find_library(
    FFTW_LONGDOUBLE_THREADS_LIB
    NAMES "fftw3l_threads"
    PATHS ${PKG_FFTW_LIBRARY_DIRS} ${LIB_INSTALL_DIR}
  )

  find_library(FFTW_LONGDOUBLE_OPENMP_LIB
          NAMES "fftw3l_omp"
          PATHS ${PKG_FFTW_LIBRARY_DIRS} ${LIB_INSTALL_DIR}
  )

  find_path(FFTW_INCLUDE_DIRS
    NAMES "fftw3.h"
    PATHS ${PKG_FFTW_INCLUDE_DIRS} ${INCLUDE_INSTALL_DIR}
  )

endif()

# If any of the required packages were not found, findFFTW will fail. If we did
# not have FFTW_USE_MKL to be true, try searching in the MKL directories.
if (NOT FFTW_USE_MKL AND (
  NOT FFTW_DOUBLE_LIB OR
  NOT FFTW_FLOAT_LIB OR
  NOT FFTW_LONGDOUBLE_LIB OR
  NOT FFTW_THREADS_LIB OR
  NOT FFTW_FLOAT_THREADS_LIB OR
  NOT FFTW_LONGDOUBLE_THREADS_LIB OR
  NOT FFTW_OPENMP_LIB OR
  NOT FFTW_FLOAT_OPENMP_LIB OR
  NOT FFTW_LONGDOUBLE_OPENMP_LIB OR
  NOT FFTW_INCLUDE_DIRS
))
  set(FFTW_USE_MKL YES)
  unset(FFTW_DOUBLE_LIB)
  unset(FFTW_FLOAT_LIB)
  unset(FFTW_LONGDOUBLE_LIB)
  unset(FFTW_THREADS_LIB)
  unset(FFTW_FLOAT_THREADS_LIB)
  unset(FFTW_LONGDOUBLE_THREADS_LIB)
  unset(FFTW_OPENMP_LIB)
  unset(FFTW_FLOAT_OPENMP_LIB)
  unset(FFTW_LONGDOUBLE_OPENMP_LIB)
  unset(FFTW_INCLUDE_DIRS)
  unset(FFTW_ROOT)
endif()

# Find MKL version of FFTW .....................................................

# If FFTW_ROOT is not set and want to use MKL, set FFTW_ROOT first
if( NOT FFTW_ROOT AND FFTW_USE_MKL )

  if ( ENV{MKLDIR} )
    set(FFTW_ROOT $ENV{MKLDIR})
  elseif(WIN32)
    set(FFTW_ROOT_default "C:/Program Files (x86)/IntelSWTools/compilers_and_libraries/windows/mkl")
  elseif(APPLE)
    set(FFTW_ROOT_default "/opt/intel/compilers_and_libraries/mac/mkl")
  elseif(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(FFTW_ROOT_default "/opt/intel/compilers_and_libraries/linux/mkl")
  else()
    message(FATAL_ERROR "System not supported for MKL.")
  endif()
  
  set(FFTW_ROOT ${FFTW_ROOT_default} CACHE PATH "Intel path containing MKL" FORCE)
endif()

if ( FFTW_USE_MKL )

  # Set FFTW include directories
  set(FFTW_INC_SEARCHPATH ${FFTW_ROOT}/include/fftw)

  find_path(FFTW_INCLUDE_PATH
    NAMES "fftw3.h"
    PATHS ${FFTW_INC_SEARCHPATH}
    NO_DEFAULT_PATH # so it finds the fftw.h file in the MKL directory
  )

  if( FFTW_INCLUDE_PATH )
    file(TO_CMAKE_PATH "${FFTW_INCLUDE_PATH}" FFTW_INCLUDE_PATH)
    set(FFTW_INCLUDE_DIRS ${FFTW_INCLUDE_PATH})
  endif()

  # Create list of FFTW libraries to find
  if(CMAKE_SIZEOF_VOID_P EQUAL "8")
    # 64-bit OS
    if(APPLE)
      set(FFTW_LIB_SEARCHPATH ${FFTW_ROOT}/lib)
    else()
      set(FFTW_LIB_SEARCHPATH ${FFTW_ROOT}/lib/intel64)
    endif()
    set(MKL_LIBRARY mkl_intel_ilp64)
    if(WIN32)
      set(MKL_OPTIONS /DMKL_ILP64)
    else()
      set(MKL_OPTIONS -DMKL_ILP64 -m64)
    endif()
  
  else()
    # not 64-bit OS
    set(FFTW_LIB_SEARCHPATH ${FFTW_ROOT}/lib/ia32)
    if(WIN)
      set(MKL_LIBRARY mkl_intel_c)
    else()
      set(MKL_LIBRARY mkl_intel)
    endif()
  endif()

  set(MKL_EXTRA_LIBRARIES mkl_core)
  list(APPEND MKL_EXTRA_LIBRARIES mkl_sequential)
  set(FFTW_LIBRARY_NAMES ${MKL_LIBRARY} ${MKL_EXTRA_LIBRARIES})
  
  macro(FFTWD_LIB_START)
    unset(FFTWD_LIB CACHE)
    unset(FFTWF_LIB CACHE)
    unset(FFTWD_THREADS_LIB CACHE)
    unset(FFTWF_THREADS_LIB CACHE)
    if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
      set(FFTWD_LIB -Wl,--start-group)
    endif()
  endmacro()

  macro(FFTWD_LIB_END)
    if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
      list(APPEND FFTWD_LIB -Wl,--end-group -lpthread -lm -ldl)
    endif()
  endmacro()

  # Find each library in FFTW_LIBRARY_NAMES
  FFTWD_LIB_START()
  foreach(LIB ${FFTW_LIBRARY_NAMES})
    string(TOUPPER ${LIB} LIB_UPPER)
    mark_as_advanced(${LIB_UPPER}_LIB)
    set(FFTW_LIBRARIES ${FFTW_LIBRARIES} ${LIB_UPPER}_LIB)
    set(LIB_NAME ${CMAKE_STATIC_LIBRARY_PREFIX}${LIB}${CMAKE_STATIC_LIBRARY_SUFFIX})
    find_library(${LIB_UPPER}_LIB ${LIB_NAME} ${FFTW_LIB_SEARCHPATH})
    if(${LIB_UPPER}_LIB)
      set(${LIB}_FOUND TRUE)
      list(APPEND FFTWD_LIB ${${LIB_UPPER}_LIB})
    else()
      message(FATAL_ERROR "${LIB_NAME} not found.")
    endif()
  endforeach()
  FFTWD_LIB_END()
  add_compile_options(${MKL_OPTIONS})

endif()

# Components :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# MKL case handled above in MKL section
if ( NOT FFTW_USE_MKL )

  if (FFTW_DOUBLE_LIB)
    set(FFTW_DOUBLE_LIB_FOUND TRUE)
    set(FFTW_LIBRARIES ${FFTW_LIBRARIES} ${FFTW_DOUBLE_LIB})
  else()
    set(FFTW_DOUBLE_LIB_FOUND FALSE)
  endif()

  if (FFTW_FLOAT_LIB)
    set(FFTW_FLOAT_LIB_FOUND TRUE)
    set(FFTW_LIBRARIES ${FFTW_LIBRARIES} ${FFTW_FLOAT_LIB})
  else()
    set(FFTW_FLOAT_LIB_FOUND FALSE)
  endif()

  if (FFTW_LONGDOUBLE_LIB)
    set(FFTW_LONGDOUBLE_LIB_FOUND TRUE)
    set(FFTW_LIBRARIES ${FFTW_LIBRARIES} ${FFTW_LONGDOUBLE_LIB})
  else()
    set(FFTW_LONGDOUBLE_LIB_FOUND FALSE)
  endif()

  if (FFTW_THREADS_LIB)
    set(FFTW_THREADS_LIB_FOUND TRUE)
    set(FFTW_LIBRARIES ${FFTW_LIBRARIES} ${FFTW_THREADS_LIB})
  else()
    set(FFTW_THREADS_LIB_FOUND FALSE)
  endif()

  if (FFTW_FLOAT_THREADS_LIB)
    set(FFTW_FLOAT_THREADS_LIB_FOUND TRUE)
    set(FFTW_LIBRARIES ${FFTW_LIBRARIES} ${FFTW_FLOAT_THREADS_LIB})
  else()
    set(FFTW_FLOAT_THREADS_LIB_FOUND FALSE)
  endif()

  if (FFTW_LONGDOUBLE_THREADS_LIB)
    set(FFTW_LONGDOUBLE_THREADS_LIB_FOUND TRUE)
    set(FFTW_LIBRARIES ${FFTW_LIBRARIES} ${FFTW_LONGDOUBLE_THREADS_LIB})
  else()
    set(FFTW_LONGDOUBLE_THREADS_LIB_FOUND FALSE)
  endif()

  if (FFTW_OPENMP_LIB)
    set(FFTW_OPENMP_LIB_FOUND TRUE)
    set(FFTW_LIBRARIES ${FFTW_LIBRARIES} ${FFTW_OPENMP_LIB})
  else()
    set(FFTW_OPENMP_LIB_FOUND FALSE)
  endif()

  if (FFTW_FLOAT_OPENMP_LIB)
    set(FFTW_FLOAT_OPENMP_LIB_FOUND TRUE)
    set(FFTW_LIBRARIES ${FFTW_LIBRARIES} ${FFTW_FLOAT_OPENMP_LIB})
  else()
    set(FFTW_FLOAT_OPENMP_LIB_FOUND FALSE)
  endif()

  if (FFTW_LONGDOUBLE_OPENMP_LIB)
    set(FFTW_LONGDOUBLE_OPENMP_LIB_FOUND TRUE)
    set(FFTW_LIBRARIES ${FFTW_LIBRARIES} ${FFTW_LONGDOUBLE_OPENMP_LIB})
  else()
    set(FFTW_LONGDOUBLE_OPENMP_LIB_FOUND FALSE)
  endif()

  #--------------------------------------- end components

  set( CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV} )

  include(FindPackageHandleStandardArgs)

  find_package_handle_standard_args(FFTW
          REQUIRED_VARS FFTW_INCLUDE_DIRS
          HANDLE_COMPONENTS
          )

  mark_as_advanced(
          FFTW_INCLUDE_DIRS
          FFTW_LIBRARIES
          FFTW_FLOAT_LIB
          FFTW_DOUBLE_LIB
          FFTW_LONGDOUBLE_LIB
          FFTW_FLOAT_THREADS_LIB
          FFTW_DOUBLE_THREADS_LIB
          FFTW_LONGDOUBLE_THREADS_LIB
          FFTW_FLOAT_OPENMP_LIB
          FFTW_DOUBLE_OPENMP_LIB
          FFTW_LONGDOUBLE_OPENMP_LIB
          )

endif()
