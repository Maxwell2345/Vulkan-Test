@echo off

echo Compiling with Ninja
ninja -C build\
if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERROR] Ninja build failed with exit code %ERRORLEVEL%!
    exit /b %ERRORLEVEL%
) else (
    echo Compile Sucessfull! Running .exe
)

cd build\
START /B /WAIT Vulkan-Test.exe
cd ../