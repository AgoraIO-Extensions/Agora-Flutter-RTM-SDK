# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

set(LIBRARY_NAME agora_rtm)

set(LIBRARY_VERSION "2.2.2")

project(${LIBRARY_NAME} VERSION ${LIBRARY_VERSION})

set(SOURCES 
     "${CMAKE_CURRENT_SOURCE_DIR}/iris_event.h"
     "${CMAKE_CURRENT_SOURCE_DIR}/iris_event.cc"
     "${CMAKE_CURRENT_SOURCE_DIR}/iris_life_cycle_observer.h"
     "${CMAKE_CURRENT_SOURCE_DIR}/iris_life_cycle_observer.cc"
     "${CMAKE_CURRENT_SOURCE_DIR}/dart-sdk/include/dart_api_dl.h"
     "${CMAKE_CURRENT_SOURCE_DIR}/dart-sdk/include/dart_api.h"
     "${CMAKE_CURRENT_SOURCE_DIR}/dart-sdk/include/dart_native_api.h"
     "${CMAKE_CURRENT_SOURCE_DIR}/dart-sdk/include/dart_tools_api.h"
     "${CMAKE_CURRENT_SOURCE_DIR}/dart-sdk/include/dart_version.h"
     "${CMAKE_CURRENT_SOURCE_DIR}/dart-sdk/include/dart_api_dl.c"
     "${CMAKE_CURRENT_SOURCE_DIR}/dart-sdk/include/internal/dart_api_dl_impl.h"
     )

add_library(${LIBRARY_NAME} SHARED
  ${SOURCES}
)

target_compile_definitions(${LIBRARY_NAME} PUBLIC DART_SHARED_LIB)

if(ANDROID)
  # Support Android 15 16k page size
  target_link_options(${LIBRARY_NAME} PRIVATE "-Wl,-z,max-page-size=16384")
endif()
