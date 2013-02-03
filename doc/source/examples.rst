Examples
==========

I will try to cover more usage details in the following examples.

Multiple Executables
=====================

This project involves multiple executables in one project.

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