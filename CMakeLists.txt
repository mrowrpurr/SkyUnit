cmake_minimum_required(VERSION 3.21)

project(SkyUnitExample VERSION 0.0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(compile_definitions)

add_executable(SkyUnitExample src/main.cpp)
