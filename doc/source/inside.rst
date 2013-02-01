Inside the Code
===============

This page is a reference to all macros/functions in ``ATSCC.cmake`` and ``FindATS.cmake``.

FindATS Module
--------------

.. sidebar:: Quick Ref
   
	Input
   		``ATSHOME`` environment variable.
   
	Output (CMake variables)
   		``ATS_HOME``
   		``ATSCC``
   		``ATSOPT``
   		``ATSCC_FLAGS``
   		``ATS_INCLUDE_DIRS``
   		``ATS_LIBRARIES``

	Effects (CMake variables for internal usage)
   		``ATS_INCLUDE_DIR``
   		``ATS_LIBRARY``
   		``CMAKE_C_COMPILER``

This is a standard CMake ``FindXXX`` module. CMake community has a documentation about how to write a ``FindXXX`` module, `here <http://www.cmake.org/Wiki/CMake_FAQ#Writing_FindXXX.cmake_files>`_. 

You have to write this in your CMakeLists.txt in order to use ATS.

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
	*For internal usage only*. This is a trick. First, ``atscc`` will call ``atsopt`` and then ``gcc`` to compile the code. Second, ``atscc`` includes many useful arguments for ``gcc`` so that it can correctly find all runtime dependencies. Thrid, by setting C compiler to ``atscc``, CMake will invoke ``atscc`` to compile C code, thus utilizing ``atscc``'s extra arguments to locate all necessary headers and libraries. You won't need to use this. But I think it's better to let you know this.

ATSCC Module
--------------

``ATS_INCLUDE (path ...)``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This macro will add all paths as directories to look up for ``SATS``/``HATS`` files. This will result in multiple ``IATS`` flags for ``atsopt``. The paths should be relative to ``${CMAKE_CURRENT_LIST_DIR}``, or they are absolute paths. You need at least one path as a parameter. 

.. admonition:: Example 

	.. code-block:: cmake

		ATS_INCLUDE (SATS HATS /usr/include/ats028/SATS)

.. admonition:: Result

	``${CMAKE_CURRENT_LIST_DIR}/SATS``, ``${CMAKE_CURRENT_LIST_DIR}/HATS`` and ``/usr/include/ats028/SATS`` will be added to ``atsopt -IATS`` flags.

``ATS_COMPILE (output src ...)``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. sidebar:: Quick Ref
   
	Input
   		``OUTPUT`` 
   			The name of the variable where to store output filenames. It is a list, not a string.
   		Source filenames
   			Specify all related files to be compiled. Seperate them using space. Only ``DATS`` and ``SATS`` files are needed.
   
	Output
		``OUTPUT`` 
			All fullpaths of C files will be stored in ``OUTPUT``.

This macro will compile all sources provided into corresponding C sources, and store all generated C file names into ``${output}`` for further use. Those file names are **absolute paths**.

The dependencies will be automatically generated. This includes two parts. *First*, all ``staload`` (for ``sats`` file) and ``#include`` (for ``hats`` file) will be detected using ``atsopt -dep1``. *Second*, all generated C files will also be involved in dependencies. For example, if ``a.sats`` includes ``a.hats``, and ``a.dats`` staload ``a.sats``. Then a dependency ``a_dats.c -> a_sats.c`` will be generated so that if ``a.hats`` changes, ``a_dats.c`` will be regenerated.

.. admonition:: Example

	.. code-block:: cmake

		ATS_COMPILE (TEST_SRC SATS/hello.sats DATS/hello.dats DATS/main.dats)

.. admonition:: Result

	 All C files compiled from ATS files are stored in ``TEST_SRC``. They are ``SATS/hello_sats.c``, ``DATS/hello_dats.c`` and ``DATS/main_dats.c``.

Note that there is no need to specify ``CATS`` files and ``HATS`` files, since ``atsopt`` will automatically find them in the paths specified by ``ATS_INCLUDE ()``.

.. warning::
	CMake has some really confusing terms, like **list** and **a list of strings**. Basically, a list is a single string where inner items are seperated using semicolon. 

Useful CMake Commands
------------------------

These are useful CMake commands. They are parts of CMake, not my project. But I think you will need them everywhere. If you need detail information, please refer to CMake offical documents.


``TARGET_LINK_LIBRARIES (target libs...)``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It will link those libraries to a specific target listed in the *same* CMake list files. Those library names could be confusing sometime. If you want to link a library file ``libzlog.so.2``, you may try ``zlog`` or ``libzlog`` as parameters to ``TARGET_LINK_LIBRARIES``.