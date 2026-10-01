find_package(Vulkan REQUIRED)

add_library(vkbootstrap STATIC)
add_library(vma INTERFACE)
add_library(stb_image INTERFACE)

target_sources(vkbootstrap PRIVATE 
    vkbootstrap/VkBootstrap.h
    vkbootstrap/VkBootstrap.cpp
    )

target_include_directories(vkbootstrap PUBLIC vkbootstrap)
target_link_libraries(vkbootstrap PUBLIC Vulkan::Vulkan $<$<BOOL:UNIX>:${CMAKE_DL_LIBS}>)

target_include_directories(vma INTERFACE vma)

add_library(imgui STATIC)

target_include_directories(imgui PUBLIC imgui)

target_sources(imgui PRIVATE
    imgui/imgui.h
    imgui/imgui.cpp 
    
    imgui/imgui_demo.cpp 
    imgui/imgui_draw.cpp 
    imgui/imgui_widgets.cpp 
    imgui/imgui_tables.cpp 
    imgui/imgui_impl_vulkan.cpp 
    imgui/imgui_impl_sdl3.cpp)

target_link_libraries(imgui PUBLIC Vulkan::Vulkan SDL3::SDL3)

target_include_directories(stb_image INTERFACE stb_image)