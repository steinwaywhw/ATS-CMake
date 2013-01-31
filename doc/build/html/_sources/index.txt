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

* Download this project. Particularly, ``FindATS.cmake`` and ``ATSCC.cmake``.
* Copy those CMake modules into CMake module dir.

  .. note::
  		Normally, the module dir is ``/usr/share/cmake-x.x.x/Modules``. You can find more information at `CMake Website <http://cmake.org/>`_.

* Start using it!

Contents:

.. toctree::
   :maxdepth: 2

   quick-start



Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

