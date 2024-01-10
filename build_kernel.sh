#!/bin/bash

########### USER EDITABLE VARIABLES ##############

ARM64_COMPILER_PATH=
BSP_SOURCES_PATH=
OUTPUT_PATH=

########### END OF USER EDITABLE SECTION #########

ARM64_COMPILER_PATH="${ARM64_COMPILER_PATH:=$(pwd)/utils/aarch64--glibc--stable-final}"
BSP_SOURCES_PATH="${BSP_SOURCES_PATH:=$(pwd)/srcs}"
OUTPUT_PATH="${OUTPUT_PATH:=$(pwd)/out}"

############ Compile BSP sources ###############
echo -n "==== Checking for sources in directory: "
echo -e "$BSP_SOURCES_PATH ====\n"
if [ ! -d $BSP_SOURCES_PATH/kernel ] || [ ! -d $BSP_SOURCES_PATH/hardware ] || [ ! -f $BSP_SOURCES_PATH/nvbuild.sh ]; then
    echo -e "==== ERROR! ===="
    echo -e "Sources not found. Execute getsources.sh or correct BSP_SOURCES_PATH variable\n"
    exit 1
fi
echo -e "==== Kernel sources found! ====\n"

echo -n "==== Checking for compiler in directory: "
echo -e "$ARM64_COMPILER_PATH ==== \n"
if [ ! -f $ARM64_COMPILER_PATH/bin/aarch64-buildroot-linux-gnu-gcc ]; then
    echo -e "==== ERROR! ===="
    echo -e "Compiler not found. Execute getsources.sh or correct ARM64_COMPILER_PATH variable\n"
    exit 1
fi
echo -e "==== Compiler found! ====\n"

echo -e "==== Starting Kernel build! ====\n"
export CROSS_COMPILE_AARCH64_PATH=$ARM64_COMPILER_PATH/
$BSP_SOURCES_PATH/nvbuild.sh -o $OUTPUT_PATH
