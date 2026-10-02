# Vulkan Test

## Table of Contents

 - [Installation](#instalation)
   - [Installation | Linux](#installation--linux)
   - [Installation | Windows](#installation--windows)

## Installation



### Installation | Linux

Vulkan-Test will run on most Linux Distros, however NixOs is the recommended distribution as this project was originally created and developed using Nix. 
There are a few required programs for this project that you must have installed before attempting to clone and install Vulkan-Test.

 - Steam
 - GCC
 - CMake
 - Pkg-Config

Please make sure that the required libraries are installed and are available before continuing installing Vulkan-Test.

1. Clone the Git Repository
   ```shell
   git clone https://github.com/Maxwell2345/Vulkan-Test.git
   ```
3. Run the setup script

   Vulkan-Test includes setup scripts to check for and install required libraries and dependencies. The setup scripts will also run the initial CMake build and pre-compile any shaders.

   If you are using NixOs, run the nix-shell command withing the project directory.
   ```shell
   nix-shell
   ```

   If you are on a different distro, run the linux-setup.sh file with sudo permissions. This script will attempt to install any needed libraries and dependencies, however it is not perfect.
   Depending on your distro, desktop environment, and windows manager, you may not be able to run SDL3 and Vulkan, which are required.
   ```shell
   chmod +x linux-setup.sh | sudo ./linux-setup.sh
   ```


### Installation | Windows

1. Download and Extract the repository.

   Download the repository .zip file from either the latest release

   -Screenshot Here-

   Or by clicking on the green <> Code button at the top of the page and clicking Download ZIP

   -Screenshot Here-

3. Run the Windows Batch File

   Within the Extracted Project folder, locate the windows-setup.bat file. Right-Click the file and select Run as Administrator

   -Screenshot Here-

   This will install GCC, CMake, SDL3, and Vulkan. Then it will run the initial CMake build and pre-compile shaders. 
