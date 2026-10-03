@echo off

echo Building CMake...
cmake -G "Ninja" -DCMAKE_C_COMPILER="C:\msys64\ucrt64\bin\gcc.exe" -DCMAKE_CXX_COMPILER="C:\msys64\ucrt64\bin\g++.exe" . -S . -B build 
echo CMake Build Finished Successfully!

echo Compiling Shaders...
cmake --build build --target Shaders
echo Shaders Compiled Successfully!