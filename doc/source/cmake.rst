Useful CMake Commands
==========================

These are useful CMake commands. They are parts of CMake, not my project. But I think you will need them everywhere. If you need detail information, please refer to CMake offical documents.

.. note:: 
	You can always check out latest usage of CMake `here <http://www.cmake.org/cmake/help/documentation.html>`_. Every commands are listed and documented.


``TARGET_LINK_LIBRARIES (target libs...)``
-----------------------------------------------

It will link those libraries to a specific target listed in the *same* CMake list files. Those library names could be confusing sometime. If you want to link a library file ``libzlog.so.2``, you may try ``zlog`` or ``libzlog`` as parameters to ``TARGET_LINK_LIBRARIES``.

``ADD_EXECUTABLE (output src ...)``
-------------------------------------------

It will produce the binary output from all the source files. 