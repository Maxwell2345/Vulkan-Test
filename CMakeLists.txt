cmake_minimum_required(VERSION 4.1.2)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

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

	# FastGLTF for GLTF Loading
	FetchContent_Declare(
		fastgltf 
		GIT_REPOSITORY  https://github.com/spnda/fastgltf.git
		GIT_TAG			v0.9.1
	)
	FetchContent_MakeAvailable(fastgltf)

	# GLM Library for Matrix Math
	FetchContent_Declare(
		glm
		GIT_REPOSITORY	https://github.com/g-truc/glm.git
		GIT_TAG 		0af55ccecd98d4e5a8d1fad7de25ba429d60e863 #refs/tags/1.0.1
	)
	FetchContent_MakeAvailable(glm)

	# String Formatting Library
	FetchContent_Declare(
		fmt
		GIT_REPOSITORY https://github.com/fmtlib/fmt.git
		GIT_TAG        11.0.2 # Use a stable version tag
	)
	FetchContent_MakeAvailable(fmt)

elseif (WIN32)
	message(STATUS "Using Windows OS")

	set(SDL3_DIR ${CMAKE_SOURCE_DIR}/libs/SDL3-3.4.16/x86_64-w64-mingw32/lib/cmake/SDL3 CACHE PATH ${CMAKE_SOURCE_DIR}/libs/SDL3-3.4.16/make/SDL3Config.cmake)
	find_package(SDL3 REQUIRED)

	# add_subdirectory(${CMAKE_SOURCE_DIR}/libs/SDL3-3.4.16)
	add_subdirectory(${CMAKE_SOURCE_DIR}/libs/fastgltf-0.9.1)
	add_subdirectory(${CMAKE_SOURCE_DIR}/libs/glm-1.0.3)
	add_subdirectory(${CMAKE_SOURCE_DIR}/libs/fmt-12.2.0)
endif()

# Find Vulkan 
find_package(Vulkan REQUIRED)

add_executable(${PROJECT_NAME} 
	Main.cpp
	Vk_Engine/vk_engine.cpp
    Vk_Engine/vk_engine.h
    Vk_Engine/vk_types.h
	Vk_Engine/vk_initializers.cpp
    Vk_Engine/vk_initializers.h
	Vk_Engine/vk_images.cpp
	Vk_Engine/vk_images.h
	Vk_Engine/vk_descriptors.cpp 
	Vk_Engine/vk_descriptors.h
	Vk_Engine/vk_pipelines.cpp 
	Vk_Engine/vk_pipelines.h
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
target_link_libraries(${PROJECT_NAME} PRIVATE imgui)
target_link_libraries(${PROJECT_NAME} PRIVATE fastgltf)

if (WIN32) 
	add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:SDL3::SDL3>
        $<TARGET_FILE_DIR:${PROJECT_NAME}>
        VERBATIM
    )
endif()

find_program(GLSL_VALIDATOR glslangValidator HINTS $ENV{VULKAN_SDK}/Bin/ $ENV{VULKAN_SDK}/Bin32/)

file(GLOB_RECURSE GLSL_SOURCE_FILES
    "${PROJECT_SOURCE_DIR}/shaders/*.frag"
    "${PROJECT_SOURCE_DIR}/shaders/*.vert"
    "${PROJECT_SOURCE_DIR}/shaders/*.comp"
    )

foreach(GLSL ${GLSL_SOURCE_FILES})
  message(STATUS "BUILDING SHADER")
  get_filename_component(FILE_NAME ${GLSL} NAME)
  set(SPIRV "${PROJECT_SOURCE_DIR}/shaders/${FILE_NAME}.spv")
  message(STATUS ${GLSL})
  add_custom_command(
    OUTPUT ${SPIRV}
    COMMAND ${GLSL_VALIDATOR} -V ${GLSL} -o ${SPIRV}
    DEPENDS ${GLSL}
	VERBATIM
	)
  list(APPEND SPIRV_BINARY_FILES ${SPIRV})
endforeach(GLSL)

add_custom_target(
    Shaders 
    DEPENDS ${SPIRV_BINARY_FILES}
    )