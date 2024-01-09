#!/bin/bash

########### USER EDITABLE VARIABLES ##############

ARM64_COMPILER_PATH=
BSP_SOURCES_PATH=
JETSON_LINUX_VERSION=r35_release_v4.1

########### END OF USER EDITABLE SECTION #########

JETSON_LINUX_VERSION="${USER_JETPACK_VERSION:=r35_release_v4.1}"

ARM64_COMPILER_PATH="${ARM64_COMPILER_PATH:=$(pwd)/utils/aarch64--glibc--stable-final}"
BSP_SOURCES_PATH="${BSP_SOURCES_PATH:=$(pwd)/srcs/}"
NVIDIA_SOURCES_URL="https://developer.nvidia.com/downloads/embedded/l4t/"$JETSON_LINUX_VERSION"/sources/public_sources.tbz2"

############ Download BSP sources ###############
echo "==== Downloading NVIDIA Kernel sources. Please wait! ==== \n"
wget $NVIDIA_SOURCES_URL -P $BSP_SOURCES_PATH

echo "==== Extracting Kernel sources. Please wait! ==== \n"
tar -xpf $BSP_SOURCES_PATH/public_sources.tbz2 -C $BSP_SOURCES_PATH "Linux_for_Tegra/source/public/kernel_src.tbz2"
mv $BSP_SOURCES_PATH/Linux_for_Tegra/source/public/kernel_src.tbz2 $BSP_SOURCES_PATH/kernel_src.tbz2
rm -r $BSP_SOURCES_PATH/Linux_for_Tegra
rm $BSP_SOURCES_PATH/public_sources.tbz2
tar -xpf $BSP_SOURCES_PATH/kernel_src.tbz2 -C $BSP_SOURCES_PATH/
rm $BSP_SOURCES_PATH/kernel_src.tbz2
echo "==== Done extracting. ==== \n"
