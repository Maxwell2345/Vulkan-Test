LIBS_DIR="libs/"

SDL3_LIB_DIR="libs/SDL3-3.4.18"
SDL3_TARBALL_PATH="libs/SDL3-3.4.18.tar.gz"
SDL3_TARBALL_URL=https://github.com/libsdl-org/SDL/releases/download/release-3.4.18/SDL3-3.4.18.tar.gz

VULKAN_LIB_DIR="libs/Vulkan-1.4.363.0"
VULKAN_TARBALL_PATH="libs/Vulkan-1.4.363.0.tar.zx"
VULKAN_TARBALL_URL=https://sdk.lunarg.com/sdk/download/1.4.363.0/linux/vulkansdk-linux-x86_64-1.4.363.0.tar.xz

FASTGLTF_LIB_DIR="libs/fastgltf-0.9.1"
FASTGLTF_TARBALL_PATH="libs/fastgltf-0.9.1.tar.gz"
FASTGLTF_TARBALL_URL=https://github.com/spnda/fastgltf/archive/refs/tags/v0.9.1.tar.gz

GLM_LIB_DIR="libs/glm-1.0.3"
GLM_TARBALL_PATH="libs/glm-1.0.3.tar.gz"
GLM_TARBALL_URL=https://github.com/g-truc/glm/archive/refs/tags/1.0.3.tar.gz

FMT_LIB_DIR="libs/fmt-12.2.0"
FMT_TARBALL_PATH="libs/fmt-12.2.0.tar.gz"
FMT_TARBALL_URL=https://github.com/fmtlib/fmt/archive/refs/tags/12.2.0.tar.gz

echo "Looking for Libs Directory"
if [ ! -d "$LIBS_DIR" ]; then
    echo "-- Libs Directory Missing. Creating Libs Directory"
    mkdir $LIBS_DIR
else 
    echo "-- Libs Directory Found"
fi

download_and_extract() {
    wget -O $2 $3
    mkdir $1
    tar -xf $2 -C $1 --strip-components=1
    rm $2
}

echo "Looking for SDL3 Lbrary"
if [ ! -e "$SDL3_LIB_DIR" ]; then 
    echo "-- Could not find SDL3 Library. Installing now"
    download_and_extract $SDL3_LIB_DIR $SDL3_TARBALL_PATH $SDL3_TARBALL_URL
else
    echo "-- SDL3 Library Found"
fi

echo "Looking for Vulkan Library"
if [ ! -e "$VULKAN_LIB_DIR" ]; then
    echo "-- Could not find Vulkan Library. Installing now..."
    download_and_extract $VULKAN_LIB_DIR $VULKAN_TARBALL_PATH $VULKAN_TARBALL_URL
else 
    echo "-- Vulkan Library Found"
fi

echo "Looking for FastGLTF Library"
if [ ! -e "$FASTGLTF_LIB_DIR" ]; then
    echo "-- Could not find FastGLTF Library. Installing now..."
    download_and_extract $FASTGLTF_LIB_DIR $FASTGLTF_TARBALL_PATH $FASTGLTF_TARBALL_URL
else 
    echo "-- FastGLTF Library Found"
fi

echo "Looking for GLM Library"
if [ ! -e "$GLM_LIB_DIR" ]; then
    echo "-- Could not find GLM Library. Installing now..."
    download_and_extract $GLM_LIB_DIR $GLM_TARBALL_PATH $GLM_TARBALL_URL
else 
    echo "-- GLM Library Found"
fi

echo "Looking for FMT Library"
if [ ! -e "$FMT_LIB_DIR" ]; then
    echo "-- Could not find FMT Library. Installing now..."
    download_and_extract $FMT_LIB_DIR $FMT_TARBALL_PATH $FMT_TARBALL_URL
else 
    echo "-- FMT Library Found"
fi

chmod +x linux-build.sh
echo ""
echo "Setup Compleate! You may now run linux-build.sh"