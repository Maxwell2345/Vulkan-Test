source libs/Vulkan-1.4.357.1/setup-env.sh

echo "Building CMake..."
if cmake -G "Ninja" . -S . -B build; then
    echo "CMake Build Finished Successfully!"
else 
    echo "CMake build failed"
    exit 1
fi 

echo "Compiling Shaders..."
if cmake --build build --target Shaders; then 
    echo "Shaders Compiled Successfully!"
else 
    echo "Shader compilation failed"
    exit 1
fi

chmod +x Vulkan-Test.sh
echo ""
echo "Build Complete! Run ./Vulkan-Test to compile and start the program."