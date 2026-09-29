cmake_minimum_required(VERSION 4.1.2)

project(Vulkan-Test)

set(SDL3_VERSION "3.4.16")
set(VULKAN_VERSION "1.4.357.1")

if (LINUX)
	message(STATUS "Using Linux OS")

	# Check for SDL3
	message(STATUS "Looking for SDL3")
	if (NOT EXISTS ${CMAKE_SOURCE_DIR}/libs/SDL3-${SDL3_VERSION})
		message(STATUS "  Could not find SDL3 Library. Looking for SDL3 Tarball...")

		if (NOT EXISTS ${CMAKE_SOURCE_DIR}/libs/SDL3-${SDL3_VERSION}.tar.gz)
			message(STATUS "  Could not find SDL Tarball. Downloading and Extracting...")
			file(DOWNLOAD https://github.com/libsdl-org/SDL/releases/download/release-${SDL3_VERSION}/SDL3-${SDL3_VERSION}.tar.gz ${CMAKE_SOURCE_DIR}/libs/SDL3-${SDL3_VERSION}.tar.gz SHOW_PROGRESS)
		else()
			message(STATUS "  SDL3 Tarball found. Extracting...")
		endif()

		execute_process(COMMAND ${CMAKE_COMMAND} -E tar xzf ${CMAKE_SOURCE_DIR}/libs/SDL3-${SDL3_VERSION}.tar.gz WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/libs)
		message(STATUS "  SDL3 Library Extracted")
	else ()
		message(STATUS "  SDL3 Library Found")
	endif()

	# Check for Vulkan
	message(STATUS "Looking for Vulkan")
	if (NOT EXISTS ${CMAKE_SOURCE_DIR}/libs/Vulkan-${VULKAN_VERSION})
		message(STATUS "  Could not find Vulkan Library. Looking for Vulkan Tarball...")

		if (NOT EXISTS ${CMAKE_SOURCE_DIR}/libs/Vulkan-${VULKAN_VERSION}.tar.xz)
			message(STATUS "  Could not fund Vulkan Tarball. Downloading and Extracting...")
			file(DOWNLOAD https://sdk.lunarg.com/sdk/download/1.4.357.1/linux/vulkansdk-linux-x86_64-1.4.357.1.tar.xz ${CMAKE_SOURCE_DIR}/libs/Vulkan-${VULKAN_VERSION}.tar.xz SHOW_PROGRESS)
		else()
			message(STATUS "  Vulkan Tarball found. Extracting...")
		endif()

		execute_process(COMMAND ${CMAKE_COMMAND} -E tar xzf ${CMAKE_SOURCE_DIR}/libs/Vulkan-${VULKAN_VERSION}.tar.xz WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/libs)
		file(RENAME ${CMAKE_SOURCE_DIR}/libs/${VULKAN_VERSION} ${CMAKE_SOURCE_DIR}/libs/Vulkan-${VULKAN_VERSION})
		message(STATUS "  Vulkan Libary Extracted")
	else() 
		message(STATUS "  Vulkan Library Found")
	endif()

elseif (WIN32)
	message(STATUS "Using Windows OS")

	#Check for SDL3

	#Check for SDL_ttf

	#check for SDL_image
endif()

find_package(PkgConfig REQUIRED)
pkg_check_modules(IBUS REQUIRED ibus-1.0)

add_executable(${PROJECT_NAME} Main.cpp)

add_subdirectory(${CMAKE_SOURCE_DIR}/libs/SDL3-${SDL3_VERSION})

find_package(Vulkan REQUIRED)

target_link_libraries(${PROJECT_NAME} PRIVATE SDL3::SDL3)
target_link_libraries(${PROJECT_NAME} PRIVATE Vulkan::Vulkan)
