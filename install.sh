LIBS_DIR="libs/"

VULKAN_LIB_PATH="libs/Vulkan-1.4.357.1"
VULKAN_TARBALL_PATH="libs/Vulkan-1.4.357.tar.zx"

echo "Looking for Libs Directory"
if [ ! -d "$LIBS_DIR" ]; then
    echo "--Libs Directory Missing. Creating Libs Directory"
    mkdir $LIBS_DIR
fi

echo "Looking for Vulkan Library"
if [ ! -e "$VULKAN_LIB_PATH" ]; then
    echo "--Could not find Vulkan Library. Looking for Vulkan Tarball..."

    if [ ! -f "$VULKAN_TARBALL_PATH" ]; then
        echo "--Could not find Vulkan Tarball. Downloading and Extracting..."
        wget -O $VULKAN_TARBALL_PATH https://sdk.lunarg.com/sdk/download/1.4.357.1/linux/vulkansdk-linux-x86_64-1.4.357.1.tar.xz
        mkdir $VULKAN_LIB_PATH
        tar -xf $VULKAN_TARBALL_PATH -C $VULKAN_LIB_PATH --strip-components=1
    else
        echo "--Vulkan Tarball found. Extracting now..."
        mkdir $VULKAN_LIB_PATH
        tar -xf $VULKAN_TARBALL_PATH -C $VULKAN_LIB_PATH --strip-components=1
    fi
else 
    echo "--Vulkan Library Found"
fi

echo "Running Vulkan setup-env.sh for Vulkan Enviroment Variables"]
chmod +x $VULKAN_LIB_PATH/setup-env.sh
./$VULKAN_LIB_PATH/setup-env.sh

echo "Executing CMakeLists.txt"
cmake -S . -B build

chmod +x Vulkan_Test.sh