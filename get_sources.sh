#!/bin/bash

########### USER EDITABLE VARIABLES ##############

ARM64_COMPILER_PATH=
BSP_SOURCES_PATH=
JETSON_LINUX_VERSION=r35_release_v4.1

########### END OF USER EDITABLE SECTION #########

ARM64_COMPILER_PATH="${ARM64_COMPILER_PATH:=$(pwd)/utils}"
JETSON_LINUX_VERSION="${USER_JETPACK_VERSION:=r35_release_v4.1}"
BSP_SOURCES_PATH="${BSP_SOURCES_PATH:=$(pwd)/srcs}"
NVIDIA_SOURCES_URL="https://developer.nvidia.com/downloads/embedded/l4t/"$JETSON_LINUX_VERSION"/sources/public_sources.tbz2"
NVIDIA_COMPILER_URL="https://developer.nvidia.com/embedded/jetson-linux/bootlin-toolchain-gcc-93"

############ Download BSP sources ###############
echo -e "==== Downloading NVIDIA Kernel sources. Please wait! ==== \n"
wget $NVIDIA_SOURCES_URL -P $BSP_SOURCES_PATH

echo -e "==== Extracting Kernel sources. Please wait! ==== \n"
tar -xpf $BSP_SOURCES_PATH/public_sources.tbz2 -C $BSP_SOURCES_PATH "Linux_for_Tegra/source/public/kernel_src.tbz2"
mv $BSP_SOURCES_PATH/Linux_for_Tegra/source/public/kernel_src.tbz2 $BSP_SOURCES_PATH/kernel_src.tbz2
rm -r $BSP_SOURCES_PATH/Linux_for_Tegra
rm $BSP_SOURCES_PATH/public_sources.tbz2
tar -xpf $BSP_SOURCES_PATH/kernel_src.tbz2 -C $BSP_SOURCES_PATH
rm $BSP_SOURCES_PATH/kernel_src.tbz2
echo -e "==== Done extracting. ==== \n"

############ Download NVIDIA recommended compiler ###############
echo -e "==== Downloading NVIDIA compiler. Please wait! ==== \n"
wget $NVIDIA_COMPILER_URL -P $ARM64_COMPILER_PATH

echo -e "==== Extracting compiler. Please wait! ==== \n"
mkdir $ARM64_COMPILER_PATH/aarch64--glibc--stable-final
tar -xpf $ARM64_COMPILER_PATH/bootlin-toolchain-gcc-93 -C $ARM64_COMPILER_PATH/aarch64--glibc--stable-final
rm $ARM64_COMPILER_PATH/bootlin-toolchain-gcc-93
echo -e "==== Done extracting. ==== \n"

############ Sources customization ###############
echo -e "==== Apply patches over kernel sources ====\n"

echo -e "==== Done applying patches! ====\n"
