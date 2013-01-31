CMAKE_MINIMUM_REQUIRED (VERSION 2.8)

#Specify project name as HELLOWORLD, and project language as C. Yes, it is C
PROJECT (HELLOWORLD C)     

#Actually, this makes CMake to find ATSCC.cmake using FindATS.cmake
FIND_PACKAGE (ATS REQUIRED) 

#The ATS_FOUND is automatically set by FindATS.cmake module
IF (NOT ATS_FOUND) 
    MESSAGE (FATAL_ERROR "ATS Not Found!")
ENDIF ()

#ATS_COMIPLE is the core of this project. To put it simple, 
#you just specify related SATS/DATS files here, and use a variable
#like TEST_SRC to store the outputs. ATS_COMPILE will analyze their 
#dependencies, compile them into C files, and store those C file 
#names into TEST_SRC

#You can use ATS_INCLUDE to add search paths for the compiler to
#find proper SATS/HATS files.    
ATS_COMPILE (TEST_SRC 
    hello.sats 
    hello.dats 
    main.dats)

#It generate the final file "test" using all the C files in TEST_SRC.
#And this is a standard CMake command
ADD_EXECUTABLE (test ${TEST_SRC}) 