cmake_minimum_required(VERSION 3.21)

project(SkyUnitExample VERSION 0.0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

find_package(websocketpp CONFIG REQUIRED)

add_definitions(-DBoost_NO_WARN_NEW_VERSIONS=1)
include(compile_definitions)
include(configure_file)

add_library(SkyUnitExample SHARED plugin/src/main.cpp plugin/include/PCH.h ${CMAKE_CURRENT_BINARY_DIR}/version.rc)
target_link_libraries(SkyUnitExample PRIVATE websocketpp::websocketpp)

find_package(CommonLibSSE CONFIG REQUIRED)
target_link_libraries(SkyUnitExample PRIVATE CommonLibSSE::CommonLibSSE)
include(compile_features)
include(precompiled_headers)

add_executable(SkyUnitTestExample tests/main.cpp)
target_link_libraries(SkyUnitTestExample PRIVATE websocketpp::websocketpp)

find_package(Boost REQUIRED COMPONENTS random)
target_link_libraries(SkyUnitTestExample PRIVATE Boost::boost Boost::random)
