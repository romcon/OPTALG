add_library(KLU SHARED 
 Source/klu.c
 Source/klu_analyze.c
 Source/klu_analyze_given.c
 Source/klu_defaults.c
 Source/klu_diagnostics.c
 Source/klu_dump.c
 Source/klu_extract.c
 Source/klu_factor.c
 Source/klu_free_numeric.c
 Source/klu_free_symbolic.c
 Source/klu_kernel.c
 Source/klu_memory.c
 Source/klu_refactor.c
 Source/klu_scale.c
 Source/klu_solve.c
 Source/klu_sort.c
 Source/klu_tsolve.c)

# Add static library target
include_directories(../AMD/include)
include_directories(../BTF/include)
include_directories(../COLAMD/include)
include_directories(../CSparse/include)
include_directories(../SuiteSparse_config)

target_include_directories(KLU PUBLIC Include)

if(WIN32)
  target_compile_options(KLU PUBLIC "-D_USRDLL")
  target_sources(KLU PUBLIC Source/klu.c)
endif()
if(UNIX)
  set(CMAKE_C_FLAGS "-O3 -fPIC")
endif()
if(APPLE)
  set(CMAKE_C_FLAGS "-O3 -fPIC")
endif()

target_link_libraries(KLU PUBLIC
 SuiteSparse_config
 AMD
 BTF
 COLAMD
 CSparse
 )


