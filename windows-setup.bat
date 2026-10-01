@echo off

title Vulkan Setup for Windows

set "LIBS_DIR=%~dp0libs"

set "VULKAN_LIB_DIR=%~dp0libs\Vulkan-1.4.363.0"
set "VULKAN_INSTALLER_DIR=%~dp0libs\vulkansdk-windows-X64-1.4.363.0"
set "VULKAN_INSTALLER_URL=https://sdk.lunarg.com/sdk/download/1.4.363.0/windows/vulkansdk-windows-X64-1.4.363.0.exe"

set "SDL3_LIB_DIR=%~dp0\libs\SDL3-3.4.16"
set "SDL3_ZIP_DIR=%~dp0\libs\SDL3-devel-3.4.16-mingw.zip"
set "SDL3_ZIP_URL=https://github.com/libsdl-org/SDL/releases/download/release-3.4.16/SDL3-devel-3.4.16-mingw.zip"

:: Look for GCC Compiler. If it is not found, install it
echo Looking for GCC Compiler
for /f "delims=" %%i in ('where gcc 2^>nul') do set "GCC_PATH=%%i"
if NOT DEFINED GCC_PATH (
    echo -- GCC Compiler not found. Installing now...
) else (
    echo -- GCC Compiler Found at: %GCC_PATH%
)

:: Look for CMake. If it is not found, install it
echo Looking for CMake
for /f "delims=" %%i in ('where cmake 2^>nul') do set "CMAKE_PATH=%%i"
if NOT DEFINED CMAKE_PATH (
    echo -- CMake not found. Installing now...
) else (
    echo -- CMake found at: %CMAKE_PATH%
)

echo Looking for Libs Directory
if not exist "%LIBS_DIR%" (
    echo -- Could not find Libs Directory. Creating Libs Directory
    mkdir "%LIBS_DIR%"
) else (
    echo -- Libs Directory Found
)

:: Install SDL3
echo Looking for SDL3 Library
if not exist "%SDL3_LIB_DIR%" (
    echo -- Could not find SDL3 Library. Looing for Libary Zip File...

    if not exist "%SDL3_ZIP_DIR%" (
        echo -- Could not find SDL3 Zip File. Downloading and Extracting now...
        curl -L -o "%SDL3_ZIP_DIR%" "%SDL3_ZIP_URL%"
        tar -xf "%SDL3_ZIP_DIR%" -C "%LIBS_DIR%"
    ) else (
        echo -- Zip File found! Extracting now...
        tar -xf "%SDL3_ZIP_DIR%" -C "%LIBS_DIR%"
    )
) else (
    echo -- SDL3 Library Found
)

:: Install Vulkan
echo Looking for Vulkan Library
if not exist "%VULKAN_LIB_DIR%" (
    echo -- Could not find Vulkan Library. Looking for Vulkan Installer...

    if not exist "%VULKAN_INSTALLER_DIR%" (
        echo -- Could not find Vulkan Installer. Downloading and Installing now...
        curl -L -o "%VULKAN_INSTALLER_DIR%" "%VULKAN_INSTALLER_URL%"
        "%VULKAN_INSTALLER_DIR%" --root "%VULKAN_LIB_DIR%" --accept-licenses --default-answer --confirm-command install
    ) else (
        echo -- Installer found!. Installing Vulkan now...
        "%VULKAN_INSTALLER_DIR%" --root "%VULKAN_LIB_DIR%" --accept-licenses --default-answer --confirm-command install
    )
) else (
    echo -- Vulkan Library Found
)

echo Executing CMakeLists.txt
::cmake -G "MinGW Makefiles" -S . -B build