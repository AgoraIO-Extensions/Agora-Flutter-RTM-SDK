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
set(AGORA_RTM_IRIS_SDK_ROOT "${AGORA_RTM_SDK_ROOT}/iris")
set(AGORA_RTM_NATIVE_SDK_ROOT "${AGORA_RTM_SDK_ROOT}/native")

function(download_and_extract_sdk label url output_dir)
  if("${url}" STREQUAL "")
    message(FATAL_ERROR
      "${label} SDK URL is empty. Run ci/run_update_deps.sh with Windows dependencies before building Windows.")
  endif()

  file(MAKE_DIRECTORY "${output_dir}")
  get_filename_component(archive_name "${url}" NAME)
  set(archive_path "${output_dir}/${archive_name}")

  if(NOT EXISTS "${archive_path}")
    message(STATUS "Downloading ${label} SDK from ${url}")
    file(DOWNLOAD "${url}" "${archive_path}" SHOW_PROGRESS STATUS download_status TLS_VERIFY ON)
    list(GET download_status 0 download_status_code)
    list(GET download_status 1 download_status_message)
    if(NOT download_status_code EQUAL 0)
      message(FATAL_ERROR "Failed to download ${label} SDK: ${download_status_message}")
    endif()
  endif()

  execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar xf "${archive_path}"
    WORKING_DIRECTORY "${output_dir}"
    RESULT_VARIABLE extract_result)
  if(NOT extract_result EQUAL 0)
    message(FATAL_ERROR "Failed to extract ${label} SDK archive: ${archive_path}")
  endif()
endfunction()

function(find_sdk_file output_var root_dir file_name)
  file(GLOB_RECURSE candidate_files "${root_dir}/*")
  set(found_file "")
  foreach(candidate IN LISTS candidate_files)
    get_filename_component(candidate_name "${candidate}" NAME)
    if(candidate_name STREQUAL "${file_name}")
      set(found_file "${candidate}")
      break()
    endif()
  endforeach()

  if("${found_file}" STREQUAL "")
    message(FATAL_ERROR "Could not find ${file_name} under ${root_dir}")
  endif()

  set(${output_var} "${found_file}" PARENT_SCOPE)
endfunction()

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/libs")
  set(AGORA_RTM_IRIS_SDK_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/libs")
  set(AGORA_RTM_NATIVE_SDK_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/libs")
else()
  download_and_extract_sdk("Iris RTM Windows" "${IRIS_SDK_DOWNLOAD_URL}" "${AGORA_RTM_IRIS_SDK_ROOT}")
  download_and_extract_sdk("Native RTM Windows" "${NATIVE_SDK_DOWNLOAD_URL}" "${AGORA_RTM_NATIVE_SDK_ROOT}")
endif()

find_sdk_file(AGORA_RTM_WRAPPER_LIB "${AGORA_RTM_IRIS_SDK_ROOT}" "AgoraRtmWrapper.lib")
target_link_libraries(${PLUGIN_NAME} PRIVATE "${AGORA_RTM_WRAPPER_LIB}")

file(GLOB_RECURSE AGORA_RTM_INCLUDE_DIRS
  LIST_DIRECTORIES true
  "${AGORA_RTM_IRIS_SDK_ROOT}/*include*"
  "${AGORA_RTM_NATIVE_SDK_ROOT}/*include*")
foreach(include_dir IN LISTS AGORA_RTM_INCLUDE_DIRS)
  if(IS_DIRECTORY "${include_dir}")
    target_include_directories(${PLUGIN_NAME} PRIVATE "${include_dir}")
  endif()
endforeach()

file(GLOB_RECURSE AGORA_RTM_NATIVE_LIBS "${AGORA_RTM_NATIVE_SDK_ROOT}/*.lib")
foreach(native_lib IN LISTS AGORA_RTM_NATIVE_LIBS)
  target_link_libraries(${PLUGIN_NAME} PRIVATE "${native_lib}")
endforeach()

file(GLOB_RECURSE AGORA_RTM_BUNDLED_DLLS
  "${AGORA_RTM_IRIS_SDK_ROOT}/*.dll"
  "${AGORA_RTM_NATIVE_SDK_ROOT}/*.dll")

if(NOT AGORA_RTM_BUNDLED_DLLS)
  message(FATAL_ERROR "No Agora RTM Windows DLLs found to bundle.")
endif()

set(agora_rtm_bundled_libraries
  ${AGORA_RTM_BUNDLED_DLLS}
  PARENT_SCOPE
)
