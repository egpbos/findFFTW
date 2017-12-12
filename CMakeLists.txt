#
# findFFTW cmake module
# Copyright (c) 2017, Patrick Bos
#
# Distributed under the terms of the BSD 3-Clause License.
#
# The full license is in the file LICENSE, distributed with this software.
#

cmake_minimum_required(VERSION 2.8)  # just some random number, didn't actually check

project(findFFTW)

#--------------------------------------- installation

include(GNUInstallDirs)

install(FILES FindFFTW.cmake
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake-findFFTW")
