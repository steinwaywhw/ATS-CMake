.. ATS CMake documentation master file, created by
   sphinx-quickstart on Wed Jan 30 17:04:30 2013.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome
=====================================

This is a project aiming at developing a build tool for ATS. It is based on CMake. Currently, it provides some very useful CMake modules for ATS users to simplify building processes. In the near future, it will support downloading artifacts from a server to help you utilize third party ATS libraries.


Quick Start
=============

* Install CMake. You can download them from `CMake Website <http://cmake.org/>`_.

  .. note:: 
		Version 2.8.3+ required, since ``ATS-CMake`` uses ``CMAKE_CURRENT_LIST_DIR`` variable

* Install ATS.

  .. note:: 
  		You need to setup environment variables ``ATSHOME`` and ``PATH`` properly. 
  		``ATS-CMake`` use them to locate your currently available ATS binaries.

* Download this project from `GitHub <https://github.com/steinwaywhw/ATS-CMake>`_. Particularly, ``FindATS.cmake`` and ``ATSCC.cmake``.

* Copy those CMake modules into CMake module dir.

  .. note::
  		Normally, the module dir is ``/usr/share/cmake-x.x.x/Modules``. You can find more information at `CMake Website <http://cmake.org/>`_.

* Start using it!

Hello World
=============

Suppose you have a small project containing ``hello.sats``, ``hello.dats`` and ``main.dats``. Then, you need to write a ``CMakeLists.txt`` like the following

.. literalinclude:: quick-demo.cmake
   :language: cmake

After you have a correct ``CMakeLists.txt``, we just need to invoke ``cmake``. But please make sure that you have a correct project layout.

.. code-block:: bash

	HelloWorld
	+---CMakeLists.txt
	+---hello.dats 
	+---hello.sats 
	+---main.dats
	\---build
	    \--- ...
	    
.. note::
	I suggest using *out-of-source* build, which makes everything clean, especially when you want to delete all temp files. See `here <http://www.cmake.org/Wiki/CMake_FAQ#Out-of-source_build_trees>`_ for more information. I use a ``./build`` dir for this purpose.

Now, go to ``./build`` and invoke ``cmake``. It will generate a ``makefile`` for you under ``./build``. You can invoke ``make`` now, to build the project as usual, and congratulations! The output binary will be under ``./build``.::

	>>> cd ./build
	>>> cmake ..
	...
	>>> make
	...

.. note::
	We use ``cmake ..`` because the present working directory is ``./build``, while the ``CMakeLists.txt`` is in the parent directory. Therefore, it is ``cmake ..`` instead of ``cmake .``. Pay attention.

What's Next
===========

In the followings, I will try to cover more use cases, and then look into what's happening in the CMake modules, so that you can better use them, and even help me develop it.

Contents:

.. toctree::
   :maxdepth: 2

   



Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

