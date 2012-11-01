CMAKE_MINIMUM_REQUIRED (VERSION 2.8)

MESSAGE (STATUS "*********************************")

MESSAGE (STATUS "Finding ZLOG")

FIND_LIBRARY (ZLOG_LIBRARY
	NAMES zlog
	PATHS ~/libs/zlog-1.2.3/lib)

GET_FILENAME_COMPONENT (ZLOG_LIBRARY ${ZLOG_LIBRARY} PATH)

FIND_PATH (ZLOG_INCLUDE_DIR
	NAMES zlog.h
	PATHS ~/libs/zlog-1.2.3/include)

INCLUDE (FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS (ZLOG DEFAULT_MSG ZLOG_LIBRARY ZLOG_INCLUDE_DIR)

SET (ZLOG_INCLUDE_DIRS ${ZLOG_INCLUDE_DIR})
SET (ZLOG_LIBRARIES ${ZLOG_LIBRARY})

MARK_AS_ADVANCED (ZLOG_INCLUDE_DIR ZLOG_LIBRARY)

MESSAGE (STATUS "Includes: ${ZLOG_INCLUDE_DIRS}")
MESSAGE (STATUS "Libraries: ${ZLOG_LIBRARIES}")

