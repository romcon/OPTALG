cmake_minimum_required(VERSION 3.18)
project(KLU)

if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS YES CACHE BOOL "Export all symbols")

if(WIN32)
  set(CMAKE_C_FLAGS "/O2 -D_WINDOWS")
endif()
if(UNIX)
  set(CMAKE_C_FLAGS "-O3 -fPIC")
endif()
if(APPLE)
  set(CMAKE_C_FLAGS "-O3 -fPIC")
endif()

# include_directories(Include)
include_directories(SuiteSparse_config)


# shared library for OpenDSS
add_subdirectory(AMD)
add_subdirectory(BTF)
add_subdirectory(COLAMD)
add_subdirectory(CSparse)
add_subdirectory(SuiteSparse_config)
add_subdirectory(KLU)


#install for deployment
install(TARGETS KLU
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        RUNTIME DESTINATION bin)

# install(TARGETS KLDemo DESTINATION "${CMAKE_SOURCE_DIR}/Test")

# Install header files
install(DIRECTORY include/AMD
	DIRECTORY include/BTF
	DIRECTORY include/CSparse
	DIRECTORY include/COLAMD
	DIRECTORY SuiteSparse_config
        DESTINATION include
        FILES_MATCHING PATTERN "*.h")
