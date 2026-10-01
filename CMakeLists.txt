cmake_minimum_required(VERSION 4.1.2)

include(FetchContent)

project(Vulkan-Test)

set(VULKAN_VERSION "1.4.357.1")

# Check if we are on Linux or Windows for SDL3
if (LINUX)
	message(STATUS "Using Linux OS")

	# SDL3 Library
	FetchContent_Declare(
    	SDL3
    	GIT_REPOSITORY "https://github.com/libsdl-org/SDL.git"
    	GIT_TAG        "release-3.4.16" # Replace with your preferred stable tag or 'main'
	)
	FetchContent_MakeAvailable(SDL3)

elseif (WIN32)
	message(STATUS "Using Windows OS")

	find_package(SDL3 REQUIRED)
endif()


# GLM Library for Matrix Math
FetchContent_Declare(
	glm
	GIT_REPOSITORY	https://github.com/g-truc/glm.git
	GIT_TAG 	0af55ccecd98d4e5a8d1fad7de25ba429d60e863 #refs/tags/1.0.1
)
FetchContent_MakeAvailable(glm)

# String Formatting Library
FetchContent_Declare(
	fmt
	GIT_REPOSITORY https://github.com/fmtlib/fmt.git
	GIT_TAG        11.0.2 # Use a stable version tag
)
FetchContent_MakeAvailable(fmt)

# Find Vulkan 
find_package(Vulkan REQUIRED)

find_package(PkgConfig REQUIRED)
pkg_check_modules(IBUS REQUIRED ibus-1.0)

add_executable(${PROJECT_NAME} 
	Main.cpp
	Vk_Engine/vk_engine.cpp
    Vk_Engine/vk_engine.h
    Vk_Engine/vk_types.h
	Vk_Engine/vk_initializers.cpp
    Vk_Engine/vk_initializers.h
	Vk_Engine/vk_images.cpp
	Vk_Engine/vk_images.h
)

target_include_directories(${PROJECT_NAME} PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/Vk_Engine")

add_subdirectory(${CMAKE_SOURCE_DIR}/third_party)

target_link_libraries(${PROJECT_NAME} PRIVATE SDL3::SDL3)
target_link_libraries(${PROJECT_NAME} PRIVATE Vulkan::Vulkan)
target_link_libraries(${PROJECT_NAME} PRIVATE glm::glm)
target_link_libraries(${PROJECT_NAME} PRIVATE fmt::fmt)
target_link_libraries(${PROJECT_NAME} PRIVATE vkbootstrap)
target_link_libraries(${PROJECT_NAME} PRIVATE vma)
target_link_libraries(${PROJECT_NAME} PRIVATE stb_image)
