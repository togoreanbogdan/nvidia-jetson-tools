#!/bin/bash

########### USER EDITABLE VARIABLES ##############

ARM64_COMPILER_PATH=$(pwd)/utils/aarch64--glibc--stable-final
BSP_SOURCES_PATH=$(pwd)/srcs
OUTPUT_PATH=$(pwd)/out
OUTPUT_ARTIFACTS=$(pwd)/release

########### END OF USER EDITABLE SECTION #########

ARM64_COMPILER_PATH="${ARM64_COMPILER_PATH:=$(pwd)/utils/aarch64--glibc--stable-final}"
BSP_SOURCES_PATH="${BSP_SOURCES_PATH:=$(pwd)/srcs}"
OUTPUT_PATH="${OUTPUT_PATH:=$(pwd)/out}"
OUTPUT_ARTIFACTS="${OUTPUT_ARTIFACTS:=$(pwd)/release}"

############ Compile BSP sources ###############
echo -e "==== Checking for sources in directory: $BSP_SOURCES_PATH ====\n"
if [ ! -d $BSP_SOURCES_PATH/kernel ] || [ ! -d $BSP_SOURCES_PATH/hardware ] || [ ! -f $BSP_SOURCES_PATH/nvbuild.sh ]; then
    echo -e "==== ERROR! ===="
    echo -e "Sources not found. Execute getsources.sh or correct BSP_SOURCES_PATH variable\n"
    exit 1
fi
echo -e "==== Kernel sources found! ====\n"

echo -e "==== Checking for compiler in directory: $ARM64_COMPILER_PATH ==== \n"
if [ ! -f $ARM64_COMPILER_PATH/bin/aarch64-buildroot-linux-gnu-gcc ]; then
    echo -e "==== ERROR! ===="
    echo -e "Compiler not found. Execute getsources.sh or correct ARM64_COMPILER_PATH variable\n"
    exit 1
fi
echo -e "==== Compiler found! ====\n"

echo -e "==== Starting Kernel build! Please wait. ====\n"
export CROSS_COMPILE_AARCH64_PATH=$ARM64_COMPILER_PATH
$BSP_SOURCES_PATH/nvbuild.sh -o $OUTPUT_PATH

############ Archive modules ###############
echo -e "==== Generating Artifacts! Please wait. ====\n"
cd $BSP_SOURCES_PATH/kernel/kernel-5.10/
make ARCH=arm64 O=$OUTPUT_PATH modules_install INSTALL_MOD_PATH=$OUTPUT_PATH/modules
cd $OUTPUT_PATH/modules
mkdir -p $OUTPUT_ARTIFACTS
tar --owner root --group root -cjf $OUTPUT_ARTIFACTS/kernel_modules.tbz2 lib/modules

############ Copy files ###############
cd $OUTPUT_PATH/arch/arm64/boot/
cp Image $OUTPUT_ARTIFACTS
mkdir -p $OUTPUT_ARTIFACTS/dtbs && cp dts/nvidia/*.dtb $OUTPUT_ARTIFACTS/dtbs/

echo -e "==== Done building. Check the artifacts folder: $OUTPUT_ARTIFACTS ====\n"
