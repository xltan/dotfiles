cmake_minimum_required(VERSION 3.10.0)
project(proj)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

SET(DEFAULT_BUILD_TYPE "RelWithDebInfo")

IF(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    MESSAGE(STATUS "Setting build type to default '${DEFAULT_BUILD_TYPE}'")
    SET(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}")
ENDIF()


# Download automatically, you can also just copy the conan.cmake file
if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
   message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
   file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/develop/conan.cmake"
                 "${CMAKE_BINARY_DIR}/conan.cmake")
endif()

include(${CMAKE_BINARY_DIR}/conan.cmake)

conan_cmake_run(CONANFILE conanfile.txt  # or relative build/conanfile.txt
                BASIC_SETUP CMAKE_TARGETS
                BUILD missing)

add_executable(proj main.cc)
target_link_libraries(proj ${CONAN_LIBS})