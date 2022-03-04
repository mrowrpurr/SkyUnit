cmake_minimum_required(VERSION 3.22)

# Set your SKSE plugin name and version.
project(
	SkyUnit
	VERSION 1.0.0
	LANGUAGES CXX
)

set(SKYUNIT_IS_MAIN_PROJECT OFF)
if (CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  set(SKYUNIT_IS_MAIN_PROJECT ON)
endif()

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(SKYUNIT_BUILD_TESTS "Build the tests for SkyUnit" ${SKYUNIT_IS_MAIN_PROJECT})

# Add options for specifying the version
# Only one version may be provided at a time
option(SKYRIM_AE "Compile plugin for Skyrim AE" OFF)
option(SKYRIM_SE "Compile plugin for Skyrim SE" OFF)
option(SKYRIM_VR "Compile plugin for Skyrim VR" OFF)

# Exit if no Skyrim version was specified
if(NOT ${SKYRIM_AE} AND NOT ${SKYRIM_SE} AND NOT ${SKYRIM_VR})
	message(FATAL_ERROR "Run cmake using one of the build/ .bat files for building Skyrim")
	return()
endif()

# Add support for #ifdef for SKYRIM_AE, SKYRIM_SE, and SKYRIM_VR
if(${SKYRIM_AE})
	message(INFO "Building CMake setup for Skyrim AE: ${SKYRIM_AE}")
	add_definitions(-DSKYRIM_AE)
	set(SKYRIM_VERSION AE)
elseif(${SKYRIM_SE})
	message(INFO "Building CMake setup for Skyrim SE: ${SKYRIM_SE}")
	add_definitions(-DSKYRIM_SE)
	set(SKYRIM_VERSION SE)
elseif(${SKYRIM_VR})
	message(INFO "Building CMake setup for Skyrim VR: ${SKYRIM_VR}")
	add_definitions(-DSKYRIM_VR)
	set(SKYRIM_VERSION VR)
endif()


# Process the .in templates in the cmake/ folder for Plugin.h and version.rc
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

# Enable testing
if(SKYUNIT_BUILD_TESTS)
	message("Build SkyUnit tests: TRUE")
	enable_testing()
	add_subdirectory(test)
endif()

# Setup SKSE project library
add_library(
	"${PROJECT_NAME}"
	INTERFACE
)
add_library("${PROJECT_NAME}::${PROJECT_NAME}" ALIAS "${PROJECT_NAME}")

# Compile with C++20 features
target_compile_features(
	"${PROJECT_NAME}"
	INTERFACE
		cxx_std_23
)

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
	target_compile_options(
		"${PROJECT_NAME}"
		INTERFACE
			"/sdl"	# Enable Additional Security Checks
			"/utf-8"	# Set Source and Executable character sets to UTF-8
			"/Zi"	# Debug Information Format

			"/permissive-"	# Standards conformance
			"/Zc:preprocessor"	# Enable preprocessor conformance mode

			"/wd4200" # nonstandard extension used : zero-sized array in struct/union

			"$<$<CONFIG:DEBUG>:>"
			"$<$<CONFIG:RELEASE>:/Zc:inline;/JMC-;/Ob3>"
	)

	target_link_options(
		"${PROJECT_NAME}"
		INTERFACE
			"$<$<CONFIG:DEBUG>:/INCREMENTAL;/OPT:NOREF;/OPT:NOICF>"
			"$<$<CONFIG:RELEASE>:/INCREMENTAL:NO;/OPT:REF;/OPT:ICF;/DEBUG:FULL>"
	)
endif()

# Default output directory for compiled files
target_include_directories(
	"${PROJECT_NAME}"
	INTERFACE
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>
)

set(ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

# CommonLib
if(${SKYRIM_AE})
	add_subdirectory("${ROOT_DIR}/CommonLib/AE" CommonLibSSE EXCLUDE_FROM_ALL)
    target_link_libraries(
        "${PROJECT_NAME}"
        INTERFACE
            CommonLibSSE::CommonLibSSE
    )
elseif(${SKYRIM_SE})
	add_subdirectory("${ROOT_DIR}/CommonLib/SE" CommonLibSSE EXCLUDE_FROM_ALL)
    target_link_libraries(
        "${PROJECT_NAME}"
        INTERFACE
            CommonLibSSE::CommonLibSSE
    )
elseif(${SKYRIM_VR})
	add_subdirectory("${ROOT_DIR}/CommonLib/VR" CommonLibVR EXCLUDE_FROM_ALL)
    target_link_libraries(
        "${PROJECT_NAME}"
        INTERFACE
            CommonLibVR::CommonLibVR
    )
endif()

# Include spdlog
find_package(spdlog CONFIG REQUIRED)
target_link_libraries("${PROJECT_NAME}" INTERFACE spdlog::spdlog)
