cmake_minimum_required(VERSION 4.1.2)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FetchContent)

project(Vulkan-Test)

set(STEAM_OPTION "")

# Check if we are on Linux or Windows for SDL3
if (LINUX)
	message(STATUS "Using Linux OS")
	set(STEAM_OPTION "steam-run")

	# SDL3 Library
	add_subdirectory(${CMAKE_SOURCE_DIR}/libs/SDL3-3.4.18)
	add_subdirectory(${CMAKE_SOURCE_DIR}/libs/fastgltf-0.9.1)
	add_subdirectory(${CMAKE_SOURCE_DIR}/libs/glm-1.0.3)
	add_subdirectory(${CMAKE_SOURCE_DIR}/libs/fmt-12.2.0)

elseif (WIN32)
	message(STATUS "Using Windows OS")

	set(SDL3_DIR ${CMAKE_SOURCE_DIR}/libs/SDL3-3.4.18/x86_64-w64-mingw32/lib/cmake/SDL3 CACHE PATH ${CMAKE_SOURCE_DIR}/libs/SDL3-3.4.18/make/SDL3Config.cmake)
	find_package(SDL3 REQUIRED)

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
    COMMAND ${STEAM_OPTION} ${GLSL_VALIDATOR} -V ${GLSL} -o ${SPIRV}
    DEPENDS ${GLSL}
	VERBATIM
	)
  list(APPEND SPIRV_BINARY_FILES ${SPIRV})
endforeach(GLSL)

add_custom_target(
    Shaders 
    DEPENDS ${SPIRV_BINARY_FILES}
    )