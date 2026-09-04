cmake_minimum_required(VERSION 3.14)

set(PROJECT_NAME "agora_rtm")
project(${PROJECT_NAME} LANGUAGES CXX)

set(PLUGIN_NAME "agora_rtm_plugin")

list(APPEND PLUGIN_SOURCES
  "agora_rtm_plugin.cpp"
  "agora_rtm_plugin.h"
)

add_library(${PLUGIN_NAME} SHARED
  "include/agora_rtm/agora_rtm_plugin_c_api.h"
  "agora_rtm_plugin_c_api.cpp"
  ${PLUGIN_SOURCES}
)

apply_standard_settings(${PLUGIN_NAME})

set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/DownloadSDK.cmake")

set(AGORA_RTM_SDK_ROOT "${CMAKE_CURRENT_BINARY_DIR}/agora_rtm_sdk")
string(SHA256 AGORA_RTM_IRIS_SDK_CACHE_KEY "${IRIS_SDK_DOWNLOAD_URL}")
string(SUBSTRING "${AGORA_RTM_IRIS_SDK_CACHE_KEY}" 0 16 AGORA_RTM_IRIS_SDK_CACHE_KEY)
string(SHA256 AGORA_RTM_NATIVE_SDK_CACHE_KEY "${NATIVE_SDK_DOWNLOAD_URL}")
string(SUBSTRING "${AGORA_RTM_NATIVE_SDK_CACHE_KEY}" 0 16 AGORA_RTM_NATIVE_SDK_CACHE_KEY)
set(AGORA_RTM_IRIS_SDK_ROOT
  "${AGORA_RTM_SDK_ROOT}/iris/${AGORA_RTM_IRIS_SDK_CACHE_KEY}")
set(AGORA_RTM_NATIVE_SDK_ROOT
  "${AGORA_RTM_SDK_ROOT}/native/${AGORA_RTM_NATIVE_SDK_CACHE_KEY}")

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(AGORA_RTM_IRIS_ARCH "x64")
  set(AGORA_RTM_NATIVE_ARCH "x86_64")
else()
  set(AGORA_RTM_IRIS_ARCH "Win32")
  set(AGORA_RTM_NATIVE_ARCH "x86")
endif()

function(download_and_extract_sdk label url output_dir)
  if("${url}" STREQUAL "")
    message(FATAL_ERROR
      "${label} SDK URL is empty. Run ci/run_update_deps.sh with Windows dependencies before building Windows.")
  endif()

  file(MAKE_DIRECTORY "${output_dir}")
  get_filename_component(archive_name "${url}" NAME)
  set(archive_path "${output_dir}/${archive_name}")
  set(download_path "${archive_path}.tmp")

  if(NOT EXISTS "${archive_path}")
    file(REMOVE "${download_path}")
    message(STATUS "Downloading ${label} SDK from ${url}")
    file(DOWNLOAD "${url}" "${download_path}" SHOW_PROGRESS STATUS download_status TLS_VERIFY ON)
    list(GET download_status 0 download_status_code)
    list(GET download_status 1 download_status_message)
    if(NOT download_status_code EQUAL 0)
      file(REMOVE "${download_path}")
      message(FATAL_ERROR "Failed to download ${label} SDK: ${download_status_message}")
    endif()
    file(RENAME "${download_path}" "${archive_path}")
  endif()

  execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar xf "${archive_path}"
    WORKING_DIRECTORY "${output_dir}"
    RESULT_VARIABLE extract_result)
  if(NOT extract_result EQUAL 0)
    file(REMOVE "${archive_path}")
    message(FATAL_ERROR
      "Failed to extract ${label} SDK archive; removed the cached archive so the next build can download it again: ${archive_path}")
  endif()
endfunction()

function(find_sdk_file output_var root_dir file_name arch_hint)
  file(GLOB_RECURSE candidate_files "${root_dir}/*")
  set(found_file "")
  foreach(candidate IN LISTS candidate_files)
    get_filename_component(candidate_name "${candidate}" NAME)
    if(candidate_name STREQUAL "${file_name}")
      if("${arch_hint}" STREQUAL "" OR candidate MATCHES "[/\\\\]${arch_hint}[/\\\\]")
        set(found_file "${candidate}")
        break()
      endif()
    endif()
  endforeach()

  set(${output_var} "${found_file}" PARENT_SCOPE)
endfunction()

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/libs")
  set(AGORA_RTM_IRIS_SDK_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/libs")
  set(AGORA_RTM_NATIVE_SDK_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/libs")
else()
  download_and_extract_sdk("Iris RTM Windows" "${IRIS_SDK_DOWNLOAD_URL}" "${AGORA_RTM_IRIS_SDK_ROOT}")
  download_and_extract_sdk("Native RTM Windows" "${NATIVE_SDK_DOWNLOAD_URL}" "${AGORA_RTM_NATIVE_SDK_ROOT}")
endif()

find_sdk_file(AGORA_RTM_WRAPPER_LIB "${AGORA_RTM_IRIS_SDK_ROOT}" "AgoraRtmWrapper.lib" "${AGORA_RTM_IRIS_ARCH}")
if("${AGORA_RTM_WRAPPER_LIB}" STREQUAL "")
  message(FATAL_ERROR "Could not find AgoraRtmWrapper.lib under ${AGORA_RTM_IRIS_SDK_ROOT}")
endif()

find_sdk_file(AGORA_RTM_WRAPPER_DLL "${AGORA_RTM_IRIS_SDK_ROOT}" "AgoraRtmWrapper.dll" "${AGORA_RTM_IRIS_ARCH}")
if("${AGORA_RTM_WRAPPER_DLL}" STREQUAL "")
  message(FATAL_ERROR "Could not find AgoraRtmWrapper.dll under ${AGORA_RTM_IRIS_SDK_ROOT}")
endif()

find_sdk_file(AGORA_RTM_NATIVE_DLL "${AGORA_RTM_NATIVE_SDK_ROOT}" "agora_rtm_sdk.dll" "${AGORA_RTM_NATIVE_ARCH}")
if("${AGORA_RTM_NATIVE_DLL}" STREQUAL "")
  message(FATAL_ERROR "Could not find agora_rtm_sdk.dll under ${AGORA_RTM_NATIVE_SDK_ROOT}")
endif()
target_link_libraries(${PLUGIN_NAME} PRIVATE "${AGORA_RTM_WRAPPER_LIB}")

file(GLOB_RECURSE AGORA_RTM_INCLUDE_DIRS
  LIST_DIRECTORIES true
  "${AGORA_RTM_IRIS_SDK_ROOT}/*include*"
  "${AGORA_RTM_NATIVE_SDK_ROOT}/*include*")
foreach(include_dir IN LISTS AGORA_RTM_INCLUDE_DIRS)
  if(IS_DIRECTORY "${include_dir}")
    get_filename_component(include_dir_name "${include_dir}" NAME)
    if(include_dir_name STREQUAL "include")
      target_include_directories(${PLUGIN_NAME} PRIVATE "${include_dir}")
    endif()
  endif()
endforeach()

file(GLOB_RECURSE AGORA_RTM_NATIVE_LIBS "${AGORA_RTM_NATIVE_SDK_ROOT}/*.lib")
set(AGORA_RTM_LINK_NATIVE_LIBS "")
foreach(native_lib IN LISTS AGORA_RTM_NATIVE_LIBS)
  if(native_lib MATCHES "[/\\\\]${AGORA_RTM_NATIVE_ARCH}[/\\\\]")
    list(APPEND AGORA_RTM_LINK_NATIVE_LIBS "${native_lib}")
  endif()
endforeach()
if(NOT AGORA_RTM_LINK_NATIVE_LIBS)
  message(FATAL_ERROR
    "No Agora RTM Windows libraries found for architecture ${AGORA_RTM_NATIVE_ARCH}.")
endif()
foreach(native_lib IN LISTS AGORA_RTM_LINK_NATIVE_LIBS)
  target_link_libraries(${PLUGIN_NAME} PRIVATE "${native_lib}")
endforeach()

file(GLOB_RECURSE AGORA_RTM_ALL_DLLS
  "${AGORA_RTM_IRIS_SDK_ROOT}/*.dll"
  "${AGORA_RTM_NATIVE_SDK_ROOT}/*.dll")
list(REMOVE_DUPLICATES AGORA_RTM_ALL_DLLS)
set(AGORA_RTM_BUNDLED_DLLS "")
foreach(bundled_dll IN LISTS AGORA_RTM_ALL_DLLS)
  if(bundled_dll MATCHES "[/\\\\]${AGORA_RTM_IRIS_ARCH}[/\\\\]" OR bundled_dll MATCHES "[/\\\\]${AGORA_RTM_NATIVE_ARCH}[/\\\\]")
    list(APPEND AGORA_RTM_BUNDLED_DLLS "${bundled_dll}")
  endif()
endforeach()
if(NOT AGORA_RTM_BUNDLED_DLLS)
  message(FATAL_ERROR
    "No Agora RTM Windows DLLs found for architecture ${AGORA_RTM_IRIS_ARCH}/${AGORA_RTM_NATIVE_ARCH}.")
endif()

set(agora_rtm_bundled_libraries
  ${AGORA_RTM_BUNDLED_DLLS}
  PARENT_SCOPE
)
