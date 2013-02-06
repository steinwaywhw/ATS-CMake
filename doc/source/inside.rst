Inside the Code
===============

This page is a reference to all macros/functions in ``ATSCC.cmake`` and ``FindATS.cmake``.

.. admonition:: Tips for filename/path

	Most of commands/macros in CMake, and most of commands of Lunix require filenames/paths contain **NO** space. So, I assume no space in any of the filenames/paths. If you get errors, first check if there is any space in any filenames/paths, and remove them. It is always good to make a :index:`space-free` filename/path.

FindATS Module
===============

``FIND_PACKAGE (ATS REQUIRED)``
-----------------------------------

.. admonition:: Quick Ref
   
	* Input 
		``ATSHOME`` environment variable.
	* Output (CMake variables)
   		``ATS_HOME``
   		``ATSCC``
   		``ATSOPT``
   		``ATSCC_FLAGS``
   		``ATS_INCLUDE_DIRS``
   		``ATS_LIBRARIES``
   		``ATS_VERBOSE``: False by default
	* Effects (CMake variables for internal usage)
   		``ATS_INCLUDE_DIR``
   		``ATS_LIBRARY``
   		``CMAKE_C_COMPILER``

This is a standard CMake ``FindXXX`` :index:`module <single: FindXXX>`. CMake community has a documentation about how to write a ``FindXXX`` module, `here <http://www.cmake.org/Wiki/CMake_FAQ#Writing_FindXXX.cmake_files>`_. You have to write this in your CMakeLists.txt in order to use ATS.

In my ``FindATS.cmake``, I use :index:`environment variable <single: ATSHOME>` ``ATSHOME`` to lookup ATS binaries. And if it is found, a series of CMake variables will be set. They are the followings.

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

``ATS_VERBOSE``:
	False by defalut. If set to ture, it will produce more informations during making process. Please set it only after ``FIND_PACKAGE (ATS ...)``. Otherwise, it will be reset to default value inside the ``FindATS`` module.

.. admonition:: Example

	.. code-block:: cmake

		FIND_PACKAGE (ATS REQUIRED) 
		IF (NOT ATS_FOUND) 
		    MESSAGE (FATAL_ERROR "ATS Not Found!")
		ENDIF ()
		
		SET (ATS_VERBOSE True)

``ATSCC``:
	It is set to the full path of ``atscc`` executable.

``ATSOPT``:
	It is set to the full path of ``atsopt`` executable.

``ATSCC_FLAGS``:
	It is set to empty.

``CMAKE_C_COMPILER``:
	*For internal usage only*. This is a trick. First, ``atscc`` will call ``atsopt`` and then ``gcc`` to compile the code. Second, ``atscc`` includes many useful arguments for ``gcc`` so that it can correctly find all runtime dependencies. Thrid, by setting C compiler to ``atscc``, CMake will invoke ``atscc`` to compile C code, thus utilizing ``atscc``'s extra arguments to locate all necessary headers and libraries. You won't need to use this. But I think it's better to let you know this.

.. admonition:: Example 

	.. code-block:: cmake

		FIND_PACKAGE (ATS REQUIRED) 

		IF (NOT ATS_FOUND) 
		    MESSAGE (FATAL_ERROR "ATS Not Found!")
		ENDIF ()

.. admonition:: Result

	If ATS is found, those commands/macros/variables will be avaiable. Otherwise, ``ATS Not Found!`` will be printed and CMake will terminate.


ATSCC Module
===============

``ATS_INCLUDE (path ...)``
------------------------------

This macro will add all paths as directories to look up for ``SATS``/``HATS`` files. This will result in multiple ``IATS`` flags for ``atsopt``. The paths should be relative to ``${CMAKE_CURRENT_LIST_DIR}``, or they are absolute paths. You need at least one path as a parameter. 

.. admonition:: Example 

	.. code-block:: cmake

		ATS_INCLUDE (SATS HATS /usr/include/ats028/SATS)

.. admonition:: Result

	``${CMAKE_CURRENT_LIST_DIR}/SATS``, ``${CMAKE_CURRENT_LIST_DIR}/HATS`` and ``/usr/include/ats028/SATS`` will be added to ``atsopt -IATS`` flags.

``ATS_COMPILE (output src ...)``
----------------------------------

.. admonition:: Quick Ref
   
	* Input
   		``OUTPUT`` 
   			The name of the variable where to store output filenames. It is a list, not a string.
   		Source filenames
   			Specify all related files to be compiled. Seperate them using space. Only ``DATS`` and ``SATS`` files are needed.
	* Output
		``OUTPUT`` 
			All fullpaths of C files will be stored in ``OUTPUT``.

This macro will compile all sources provided into corresponding C sources, and store all generated C file names into ``${output}`` for further use. Those file names are **absolute paths**.

The :index:`dependencies` will be automatically generated. This includes two parts. *First*, all ``staload`` (for ``sats`` file) and ``#include`` (for ``hats`` file) will be detected using ``atsopt -dep1``. *Second*, all generated C files will also be involved in dependencies. For example, if ``a.sats`` includes ``a.hats``, and ``a.dats`` staload ``a.sats``. Then a dependency ``a_dats.c -> a_sats.c`` will be generated so that if ``a.hats`` changes, ``a_dats.c`` will be regenerated.

.. admonition:: Example

	.. code-block:: cmake

		ATS_COMPILE (TEST_SRC SATS/hello.sats DATS/hello.dats DATS/main.dats)

.. admonition:: Result

	 All C files compiled from ATS files are stored in ``TEST_SRC``. They are ``SATS/hello_sats.c``, ``DATS/hello_dats.c`` and ``DATS/main_dats.c``.

Note that there is no need to specify ``CATS`` files and ``HATS`` files, since ``atsopt`` will automatically find them in the paths specified by ``ATS_INCLUDE ()``.

.. warning::
	CMake has some really confusing terms, :index:`like <single: list and string>` **list** and **string**. Basically, a list is a single string where inner items are seperated using semicolon, while a string is seperated using spaces. ``set (MyString "Hello World")`` will give you a string, while ``set (MyList Hello World)`` will give you a list, which is stored as ``Hello;World``. Also, you need to pay attention to quotes. ``set (MyString2 "${MyString}")`` will be a string, while ``set (MyList2 ${MyString})`` will be a list, since it will evaluate to ``set (MyList2 Hello World)``. You should search "CMake List String" on Google for more information.

``ATS_DEPGEN (OUTPUT SRC)``  :sub:`(For internal usage only)`
------------------------------------------------------------------

.. admonition:: Quick Ref

	* Input:
		A single source file path.

	* Output:
		``${OUTPUT}`` will contain space separated dependencies. It is a string, not a list. All dependencies are fullpaths.

It is called by ``ATS_COMPILE ()``. It runs ``atsopt`` to generate ATS dependencies. For example, if ``hello.dats`` depends on ``hello.sats``, it will append the fullpath of ``hello.sats`` to the output. Later, it will call ``ATS_DEPGEN_C ()`` to generate C dependencies. Take the above example, it will make ``hello_dats.c`` depends on ``hello_sats.c``. This enables ``hello_dats.c`` to be regenerated when ``hello.sats`` is modified.



``ATS_DEPGEN_C (DEP)``  :sub:`(For internal usage only)`
-----------------------------------------------------------

.. admonition:: Quick Ref

	* Input:
		All dependencies for a source file.

	* Output:
		C dependencies will be appended.

It is called by ``ATS_DEPGEN ()``. For example, if we have ``1.sats <- 2.sats``, then we add ``1_sats.c <- 2_sats.c``.

This is useful when ``1.sats`` inludes a ``HATS`` file. When the HATS file updates, ``1.sats`` is not changed, but ``1_sats.c`` is changed. And since ``2.sats`` depends on ``1.sats`` and it is not changed, ``2_sats.c`` is not recompiled. However, it should be recompiled since the actual meaning of ``1.sats`` has been changed. Thus, we need to append C dependencies.

