Examples
==========

I will try to cover more usage details in the following examples.

Multiple Executables
=====================

This project involves multiple executables in one project. Source files can be found `here <https://github.com/steinwaywhw/ATS-CMake/tree/master/doc/source/SimpleUsage>`_.

.. code-block:: bash

	SimpleUsage
	|   CMakeLists.txt      
	|   gcd.dats			# compute GCD using lambda
	|   lambda.dats			# implementation of simple lambda calculas
	|   lambda.sats			# definition of simple lambda calculas
	|   lambda_env.dats		# lambda evaluation environment
	|   prime.dats			# compute prime number using lambda
	|   
	\---build				# out-of-source build dir
	        ...

What we want are two executables, ``gcd`` and ``prime``. 

.. literalinclude:: SimpleUsage/CMakeLists.txt
   :language: cmake


Local CMake Modules
=======================

Sometimes, you may want to use these CMake moduls locally. I will modify the last example with locally loaded ATS modules. Source files can be found `here <https://github.com/steinwaywhw/ATS-CMake/tree/master/doc/source/LocalModule>`_.

.. code-block:: bash

	LocalModule
	|   CMakeLists.txt
	|   gcd.dats
	|   lambda.dats
	|   lambda.sats
	|   lambda_env.dats
	|   prime.dats
	|   
	+---build
	\---cmake
	        ATSCC.cmake
	        FindATS.cmake

I put the CMake modules under ``${CMAKE_CURRENT_SOURCE_DIR}/cmake``. And the ``CMakeLists.txt`` should be updated as follows.

.. literalinclude:: LocalModule/CMakeLists.txt
   :language: cmake
   :emphasize-lines: 4,5
