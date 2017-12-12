#
# findFFTW cmake module TEST
# Copyright (c) 2017, Patrick Bos
#
# Distributed under the terms of the BSD 3-Clause License.
#
# The full license is in the file LICENSE, distributed with this software.
#

# Run this to test whether the find module was installed properly.

cmake_minimum_required(VERSION 2.8)  # just some random number, didn't actually check

include(GNUInstallDirs)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/cmake-findFFTW")

message("CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")

project(findFFTWtest)

find_package(FFTW QUIET)
if ("${FFTW_FOUND}" STREQUAL "0")
    message(FATAL_ERROR "Did not find findFFTW, test failed")
elseif("${FFTW_FOUND}" STREQUAL "TRUE" OR "${FFTW_FOUND}" STREQUAL "FALSE")
    message("findFFTW was found and ran successfully (FFTW_FOUND: ${FFTW_FOUND}), test successful")
endif()
