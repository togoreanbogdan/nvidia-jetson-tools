### Nvidia-Jetson-tools
Collection of tools for Nvidia Jetson

## Usage instructions
- __get_sources.sh__ script is used for cloning the Nvidia Linux Kernel sources from Nvidia servers.

  In the first part of the script there are defined a set of variables. These can be edited by the user to set the output/sources paths or can be left default
    - __ARM64_COMPILER_PATH__ - specify the path where should be downloaded the Nvidia approved ARM64 compiler
    - __BSP_SOURCES_PATH__ - specify the path where will be downloaded the kernel sources
    - __JETSON_LINUX_VERSION__ - set the L4T version to be used. By default it is set to R35.4.1 which corresponds to JetPack 5.1.2
    - __TAG__ - variable set the git tag to be used when sources are cloned
    - __SOURCE_INFO__ - is an array of sources lists. Each element store the download destination, followed by repo URL, followed by the git tag. The separator used is __;__
  
- __build_kernel.sh__ script is used to automate the Nvidia kernel, modules and devicetrees build process. It required the kernel sources to be already fetched using _get_sources.sh_ or manually.
After a succesful run it will generate an output folder which store the built binaries and an release artifacts folder which contain the kernel Image, the devicetree blobs and the archived modules.
This script also contains some user configurable variables:
    - __ARM64_COMPILER_PATH__ - specify the path where the ARM64 compiler is located. If compiler was downloaded using _get_sources.sh_ this variable should be left in the default state
    - __BSP_SOURCES_PATH__ - specify the path where are located the Nvidia kenrel sources. If sources were downloaded using _get_sources.sh_ this variable should be left in the default state
    - __OUTPUT_PATH__ - set the folder where will be stored the compiled binaries
    - __OUTPUT_ARTIFACTS__ - set the folder where will be copyed the release artifacts which further needs to be installed on the Nvidia target

## Artifacts instalation on the target
The __build_kernel.sh__ script will generate the kernel Image, devicetree blobs and kernel modules archive and store them by default in _release_ folder. Further the user needs to manuall copy the artifacts on to the target.
The target destination folders for artifacts are:

- __Image__ should be copyed on the target in __/boot/__ and is the Nvidia Linuxx kernel image
- __dtbs__ - is a folder conatining devicetree blobs. It should be copyed on the target in __/boot/dtb/__
- __kernel_modules.tbz2__ - is an archive containing the kernel modules. Kernel image an kernel modules should be in sync. The archive should be copyed on the target and extracted in __/usr/__ folder.
For example the following command can be used on the target:
```
  sudo tar -xpvf kernel_modules.tbz2 -C /usr/
  sudo depmod -a
```
