## Burn new Linux Kernel image inside SD card.
## Argument $1 contains the sdXX device that is asigned to the SD card

sudo -E make flash-sdcard SDDEVICE=/dev/${1}
