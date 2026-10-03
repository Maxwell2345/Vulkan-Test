@echo off

title Vulkan Setup for Windows

set "LIBS_DIR=%~dp0\libs"

set "MSYS2_DIR=C:\msys64"
set "MSYS2_INSTALLER_PATH=%~dp0\libs\msys2-x86_64-20260927.exe"
set "MSYS2_INSTALLER_URL=https://github.com/msys2/msys2-installer/releases/download/2026-09-27/msys2-x86_64-20260927.exe"
set "GCC_ENVIROMENT_VARIABLES_PATH=C:\msys64\ucrt64\bin"

set "CMAKE_INSTALLER_PATH=%~dp0\libs\cmake-4.4.4-windows-x86_64.msi"
set "CMAKE_INSTALLER_URL=https://github.com/Kitware/CMake/releases/download/v4.4.4/cmake-4.4.4-windows-x86_64.msi"

set "VULKAN_LIB_DIR=%~dp0\libs\Vulkan-1.4.363.0"
set "VULKAN_INSTALLER_PATH=%~dp0\libs\vulkansdk-windows-X64-1.4.363.0"
set "VULKAN_INSTALLER_URL=https://sdk.lunarg.com/sdk/download/1.4.363.0/windows/vulkansdk-windows-X64-1.4.363.0.exe"

set "SDL3_LIB_DIR=%~dp0\libs\SDL3-3.4.16"
set "SDL3_ZIP_PATH=%~dp0\libs\SDL3-3.4.16.zip"
set "SDL3_ZIP_URL=https://github.com/libsdl-org/SDL/releases/download/release-3.4.18/SDL3-devel-3.4.18-mingw.zip"

set "FASTGLTF_LIB_DIR=%~dp0\libs\fastgltf-0.9.1"
set "FASTGLTF_ZIP_PATH=%~dp0\libs\fastgltf-0.9.1.zip"
set "FASTGLTF_ZIP_URL=https://github.com/spnda/fastgltf/archive/refs/tags/v0.9.1.zip"

set "GLM_LIB_DIR=%~dp0\libs\glm-1.0.3"
set "GLM_ZIP_PATH=%~dp0\libs\glm-1.0.3.zip"
set "GLM_ZIP_URL=https://github.com/g-truc/glm/releases/download/1.0.3/glm-1.0.3.zip"

set "FMT_LIB_DIR=%~dp0\libs\fmt-12.2.0"
set "FMT_ZIP_PATH=%~dp0\libs\fmt-12.2.0.zip"
set "FMT_ZIP_URL=https://github.com/fmtlib/fmt/releases/download/12.2.0/fmt-12.2.0.zip"


rem Look for libs directory. If not found create it
echo Looking for Libs Directory
if not exist "%LIBS_DIR%" (
    echo -- Could not find Libs Directory. Creating Libs Directory
    mkdir "%LIBS_DIR%"
) else (
    echo -- Libs Directory Found
)

rem Look for GCC Compiler. If it is not found, install it
echo Looking for GCC Compiler
for /f "delims=" %%i in ('where gcc 2^>nul') do set "GCC_PATH=%%i"
if NOT DEFINED GCC_PATH (
    echo -- GCC Compiler not found. Looking for MSYS2...

    rem Look for MSYS2. If it is not found, install it
    if not exist "%MSYS2_DIR%" (
        echo -- Could not find MSYS2. Installing now...

        rem Download MSYS2 Installer
        curl -L -o "%MSYS2_INSTALLER_PATH%" "%MSYS2_INSTALLER_URL%"

        rem Run MSYS2 Installer
        START "" /B /WAIT "%MSYS2_INSTALLER_PATH%" --root "%MSYS2_DIR%" --accept-licenses --default-answer --confirm-command install

        rem Delete MSYS2 Installer
        del "%MSYS2_INSTALLER_PATH%"
    ) else (
        echo -- MSYS2 Found. Installing MinGW GCC
    )

    rem Install MinGW GCC
    START "" /B /WAIT cmd.exe /C ""%MSYS2_DIR%"\msys2_shell.cmd -defterm -no-start -ucrt64 -c "pacman --noconfirm -S base-devel mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-ninja""

    rem Set GCC Eviroment Variables
    setx PATH "%GCC_ENVIROMENT_VARIABLES_PATH%"
) else (
    echo -- GCC Compiler Found at: %GCC_PATH%
)

rem Look for CMake. If it is not found, install it
echo Looking for CMake
for /f "delims=" %%i in ('where cmake 2^>nul') do set "CMAKE_PATH=%%i"
if NOT DEFINED CMAKE_PATH (
    echo -- CMake not found. Installing now...

    rem Download CMake Installer
    curl -L -o "%CMAKE_INSTALLER_PATH%" "%CMAKE_INSTALLER_URL%"

    rem Run CMake Installer
    START /WAIT msiexec.exe /i "%CMAKE_INSTALLER_PATH%" /qn /norestart ADD_CMAKE_TO_PATH=System

    rem Delete CMake Installer
    del "%CMAKE_INSTALLER_PATH%"
)  else (
    echo -- CMake found at: %CMAKE_PATH%
)

rem Look for SDL3. If not found install it
echo Looking for SDL3 Library
if not exist "%SDL3_LIB_DIR%" (
    echo -- Could not find SDL3 Library. Looing for Libary Zip File...

    rem Download SDL3 Zip File
    curl -L -o "%SDL3_ZIP_PATH%" "%SDL3_ZIP_URL%"

    rem Extract SDL3 Zip File
    mkdir "%SDL3_LIB_DIR%"
    tar -xf "%SDL3_ZIP_PATH%" -C "%SDL3_LIB_DIR%" --strip-components=1

    rem Delete SDL3 Zip File
    del "%SDL3_ZIP_PATH%"
) else (
    echo -- SDL3 Library Found
)

rem Look for Vulkan Library, If not found install it
echo Looking for Vulkan Library
if not exist "%VULKAN_LIB_DIR%" (
    echo -- Could not find Vulkan Library. Installing now...

    rem Download Vulkan Installer
    curl -L -o "%VULKAN_INSTALLER_PATH%" "%VULKAN_INSTALLER_URL%"

    rem Run Vulkan Installer
    START "" /B /WAIT "%VULKAN_INSTALLER_PATH%" --root "%VULKAN_LIB_DIR%" --accept-licenses --default-answer --confirm-command install

    rem Delete Vulkan Installer
    del "%VULKAN_INSTALLER_PATH%"
) else (
    echo -- Vulkan Library Found
)

rem Look for FastGLTF Library. If not found install it
echo Looking for FastGLTF Library
if not exist "%FASTGLTF_LIB_DIR%" (
    echo -- Could not find FastGLTF Library. Installing now...

    rem Downlaod FastGLTF Zip File
    curl -L -o "%FASTGLTF_ZIP_PATH%" "%FASTGLTF_ZIP_URL%"

    rem Extract the FastGLTF Zip File
    mkdir "%FASTGLTF_LIB_DIR%"
    tar -xf "%FASTGLTF_ZIP_PATH%" -C "%FASTGLTF_LIB_DIR%" --strip-components=1

    rem Delete FastGLTF Zip File
    del "%FASTGLTF_ZIP_PATH%"
) else (
    echo -- FastGLTF Library Found
)

rem Look for GLM Library. If not found install it
echo Looking for GLM Library
if not exist "%GLM_LIB_DIR%" (
    echo -- Could not find GLM Library. Installing now...

    rem Downlaod GLM Zip file
    curl -L -o "%GLM_ZIP_PATH%" "%GLM_ZIP_URL%"

    rem Extract GLM Zip File
    mkdir "%GLM_LIB_DIR%"
    tar -xf "%GLM_ZIP_PATH%" -C "%GLM_LIB_DIR%" --strip-components=1

    rem Delete GLM Zip File
    del "%GLM_ZIP_PATH%"
) else (
    echo -- GLM Library Found
)

rem Look for FMT Library. If not found install it
echo Looking for FMT Library
if not exist "%FMT_LIB_DIR%" (
    echo -- Could not find FMT Library. Installing now...

    rem Download FMT Zip file
    curl -L -o "%FMT_ZIP_PATH%" "%FMT_ZIP_URL%"

    rem Extract FMT Zip file
    mkdir "%FMT_LIB_DIR%"
    tar -xf "%FMT_ZIP_PATH%" -C "%FMT_LIB_DIR%" --strip-components=1

    rem Delete FT Zip file
    del "%FMT_ZIP_PATH%"
) else (
    echo - FMT Library Found
)

echo Done. You may now run windows-build.bat