##*********************************************************************##
##                                                                     ##
##                        Applied Type System                          ##
##                                                                     ##
##*********************************************************************##

##
## ATS/Postiats - Unleashing the Potential of Types!
## Copyright (C) 2011-2012 Hongwei Xi, ATS Trustful Software, Inc.
## All rights reserved
##
## ATS is free software;  you can  redistribute it and/or modify it under
## the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by the
## Free Software Foundation; either version 2.1, or (at your option)  any
## later version.
##
## ATS is distributed in the hope that it will be useful, but WITHOUT ANY
## WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
## for more details.
##
## You  should  have  received  a  copy of the GNU General Public License
## along  with  ATS;  see the  file COPYING.  If not, please write to the
## Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
## 02110-1301, USA.
##

##
## A CMake module for building ATS projects. 
##
## Contributed by Hanwen Wu (hwwu AT bu DOT edu)
##
## Time: December, 2012
##

##
## License: LGPL 3.0 (available at http://www.gnu.org/licenses/lgpl.txt)
##


CMAKE_MINIMUM_REQUIRED (VERSION 2.8)

MESSAGE (STATUS "*********************************")
MESSAGE (STATUS "Finding ATS")

INCLUDE (ATSCC)



FIND_PATH (ATS_HOME
	NAMES bin/atscc
	PATHS ENV ATSHOME)

SET (ATS_INCLUDE_DIR ${ATS_HOME} ${ATS_HOME}/ccomp/runtime)
SET (ATS_LIBRARY ${ATS_HOME}/ccomp/lib)

INCLUDE (FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS (ATS DEFAULT_MSG ATS_LIBRARY ATS_INCLUDE_DIR)

SET (ATS_INCLUDE_DIRS ${ATS_INCLUDE_DIR})
SET (ATS_LIBRARIES ${ATS_LIBRARY})

MARK_AS_ADVANCED (ATS_INCLUDE_DIR ATS_LIBRARY)

SET (CMAKE_C_COMPILER atscc)
SET (ATSCC_FLAGS)

SET (ATSCC ${ATS_HOME}/bin/atscc)
SET (ATSOPT ${ATS_HOME}/bin/atsopt)

MESSAGE (STATUS "ATS Home: ${ATS_HOME}")
MESSAGE (STATUS "Includes: ${ATS_INCLUDE_DIRS}")
MESSAGE (STATUS "Libraries: ${ATS_LIBRARIES}")