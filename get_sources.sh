#!/bin/bash

########### USER EDITABLE VARIABLES ##############

ARM64_COMPILER_PATH=$(pwd)/utils
BSP_SOURCES_PATH=$(pwd)/srcs
JETSON_LINUX_VERSION=r35_release_v4.1
TAG=v1.0.0
SOURCE_INFO=(
"kernel/nvidia;https://github.com/togoreanbogdan/linux-nvidia.git;$TAG"
"kernel/nvidia/drivers/net/ethernet/nvidia/nvethernet/nvethernetrm;https://nv-tegra.nvidia.com/kernel/nvethernetrm.git;jetson_35.4.1"
"hardware/nvidia/platform/t23x/p3768/kernel-dts;https://github.com/togoreanbogdan/hardware-nvidia-platform-t23x-p3768-dts.git;$TAG"
)
CLONE_SOURCES=1

########### END OF USER EDITABLE SECTION #########

ARM64_COMPILER_PATH="${ARM64_COMPILER_PATH:=$(pwd)/utils}"
JETSON_LINUX_VERSION="${USER_JETPACK_VERSION:=r35_release_v4.1}"
BSP_SOURCES_PATH="${BSP_SOURCES_PATH:=$(pwd)/srcs}"
NVIDIA_SOURCES_URL="https://developer.nvidia.com/downloads/embedded/l4t/"$JETSON_LINUX_VERSION"/sources/public_sources.tbz2"
NVIDIA_COMPILER_URL="https://developer.nvidia.com/embedded/jetson-linux/bootlin-toolchain-gcc-93"
CLONE_SOURCES="${CLONE_SOURCES:=0}"

if [ $CLONE_SOURCES -eq 1 ]; then

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

fi

############ Sources customization ###############
echo -e "==== Processing sources list ====\n"
NSOURCES=${#SOURCE_INFO[@]}
for ((i=0; i < NSOURCES; i++)); do
	WHAT=$(echo "${SOURCE_INFO[i]}" | cut -f 1 -d ';')
	REPO=$(echo "${SOURCE_INFO[i]}" | cut -f 2 -d ';')
	TAG=$(echo "${SOURCE_INFO[i]}" | cut -f 3 -d ';')
	echo -e "==== Apply patches over kernel sources $WHAT ====\n"

	PATCH_DIR=$BSP_SOURCES_PATH/$WHAT
    if [ -d $PATCH_DIR ]; then
        echo -e "Folder $PATCH_DIR already exist. Cleaning\n"
        rm -rf $PATCH_DIR
    fi
    git clone --branch $TAG $REPO $PATCH_DIR
done

echo -e "==== Done applying patches! ====\n"
