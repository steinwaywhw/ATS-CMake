Inside the Code
===============

This page is a reference to all macros/functions in ``ATSCC.cmake`` and ``FindATS.cmake``.

FindATS Module
--------------

.. sidebar:: Sidebar Title
   :subtitle: Optional Sidebar Subtitle

   Subsequent indented lines comprise
   the body of the sidebar, and are
   interpreted as body elements.

This is a standard CMake ``FindXXX`` module. CMake community has a documentation about how to write a ``FindXXX`` module, `here <http://www.cmake.org/Wiki/CMake_FAQ#Writing_FindXXX.cmake_files>`_. 

In my ``FindATS.cmake``, I use environment variable ``ATSHOME`` to lookup ATS binaries. And if it is found, a series of CMake variables will be set. They are the followings.

``ATS_Home``: 
	Set to the same value as environment variable ``ATSHOME``.

``ATS_INCLUDE_DIR``:
	*For internal usage only*. Set to the include directories of ATS. Its value is ``${ATS_HOME}/ccomp/runtime``.

``ATS_LIBRARY``:
	*For internal usage only*. Set to the link directories of ATS. Its value is ``${ATS_HOME}/ccomp/lib``.

``ATS_INCLUDE_DIRS``:
	Its the same value as ``${ATS_INCLUDE_DIR}``, but it is for users.

``ATS_LIBRARIES``:
	Its the same value as ``${ATS_LIBRARY}``, but it is for users.

.. note::
	These two internal variables and two user variables are compliant to CMake naming conventions. Please refer to CMake documentations.

``ATSCC``:
	It is set to the full path of ``atscc`` executable.

``ATSOPT``:
	It is set to the full path of ``atsopt`` executable.

``ATSCC_FLAGS``:
	It is set to empty.

``CMAKE_C_COMPILER``:
	*For internal usage only*. This is a trick. First, ``atscc`` will call ``atsopt`` and then ``gcc`` to compile the code. Second, ``atscc`` includes many useful arguments for ``gcc`` so that it can correctly find all runtime dependencies. Thrid, by setting C compiler to ``atscc``, CMake will invoke ``atscc`` to compile C code, thus utilizing ``atscc``'s extra arguments. You won't need to use this. But I think it's better to let you know this.

ATSCC Module
--------------

``ATS_INCLUDE (path ...)``
^^^^^^^^^^^^^^^^^^^^


This macro will add all paths as directories to look for SATS/HATS files. This will result in multiple IATS flags for atsopt. The paths should be relative to $(CMAKE_CURRENT_LIST_DIR), or they are absolute paths.

Example: ATS_INCLUDE (SATS HATS /usr/include/ats028/SATS)

Result: ${CMAKE_CURRENT_LIST_DIR}/SATS, ${CMAKE_CURRENT_LIST_DIR}/HATS and /usr/include/ats028/SATS will be added to atsopt -IATS flags.

ATS_COMPILE (output src ...)
This macro will compile all sources provided into corresponding C sources, and store all generated C file names into ${output} for further use. Those file names are absolute paths.

The dependencies will be automatically generated. This includes two parts. First, all staload(for sats file) and #include(for hats file) will be detected using atsopt -dep1. Second, all generated C files will also be involved in dependencies. For example, if a.sats includes a.hats, and a.dats staload a.sats. Then a dependency a_dats.c -> a_sats.c will be generated so that if a.hats changes, a_dats.c will be regenerated.

Example: ATS_COMPILE (TEST_SRC SATS/hello.sats DATS/hello.dats DATS/main.dats)

Result: All C files compiled from ATS files are stored in TEST_SRC.

Note that there is no need to specify CATS files and HATS files, since atsopt will automatically find them in the paths specified by ATS_INCLUDE.

FIND_PACKAGE (ATS REQUIRED)
This is a macro which looks for ATS installations and sets up necessary variables in CMake. You have to write this in your CMakeLists.txt in order to use ATS.

Inside this macro, it will look for ATSHOME environment variable, and then locate atscc, atsopt execuatables. They can be accessed through ${ATS_HOME}, ${ATSCC} and ${ATSOPT} in CMake.

Also, it will setup link dirs and include dirs as ${ATS_LIBRARIES} and ${ATS_INCLUDE_DIRS}, whose values are ${ATS_HOME}/ccomp/lib and ${ATS_HOME}/ccomp/runtime.

And, one of the most important thing is to set CMAKE_C_COMPILER to atscc, instead of gcc or cc. This is because whenever CMake wants to compile a C file, it will be served by atscc so that it can locate ATS runtime libraries and headers correctly and completely.

TARGET_LINK_LIBRARIES (target libs...)
This is a CMake standard command, which will link those libraries to a specific target listed in the same CMake list files. Those library names could be confusing sometime. If you want to link a library file libzlog.so.2, you may try zlog or libzlog as parameters to TARGET_LINK_LIBRARIES.