Hardware Trojans implemented for RISC-V designs.

## IEEE HOST 2024: Towards Practical Fabrication Stage Attacks Using Interrupt-Resilient Hardware Trojans
In this update we are releasing the Interrupt-Resilient Trojan design logic.
The IRTs have been tested against the [CVA6](https://github.com/openhwgroup/cva6) RISC-V micro-architecture.
The next update will include the control software, as well as pre-build bitstreams and Linux images ready to be tested.

If you are using the IRT trojan designs in a scientific publication, we kindly request you to cite our work:

```
@INPROCEEDINGS {10545403,
author = {A. Moschos and F. Monrose and A. D. Keromytis},
booktitle = {2024 IEEE International Symposium on Hardware Oriented Security and Trust (HOST)},
title = {Towards Practical Fabrication Stage Attacks Using Interrupt-Resilient Hardware Trojans},
year = {2024},
}

```

## File structure:
Design under attack: CVA6 RISC-V microarchitecture - https://github.com/openhwgroup/cva6

What's included in this deliverable version:

1) `main.sh`: A Bash script that downloads the CVA6 Github repo and switches the repo's HEAD to the latest commit we used for the implementation of the IRT trojans 
The script creates a "DIFFs.txt" log file with the differences between the original repo RTL code and the trojan-RTL code.
The trojan-RTL code is copied to the appropriate CVA6 directories and the generation of a new trojan-CVA6 bitstream is initiated 
The final outcomes are the "ariane_xilinx.mcs" and "ariane_xilinx.bit" files that can be loaded on a Genesys2 board for testing.

IMPORTANT: We are using the tools suggested in the CVA6 repository, for the generation of the trojan-bitstream.
Therefore, for the shell script to work correctly, it is assumed that a user has followed the steps described in the CVA6's repository guide to install the risc-v toolchain.
Bofore running the shell script, both the risc-v toolchain and Xilinx's Vivado should be in `$PATH`.

2) `irt_rtl`: This folder contains the RTL code of the IRT-1 and IRT-2 trojans, as well as the necessary modifications to the rest of the CVA6 logic.  

3) `bitstreams`: This fodler contains ready-to-use bitstreams of the CVA6 uArch with the IRT-1 and IRT-2 trojans.
For each of the trojan-bistreams, a "clean" CVA6 bitstream is provided, which has the exact layout as the trojan-bitstream, without the inclusion of the trojan.
Therefore, the bitstreams permit the experimentation on side-channel based hardware trojan detection methods.
The bitstreams have been generated for the Genesys2 board.

4) `stand_alone`: This folder contains the "uImage" and "fw_payload.bin" files that will be burned in the SD card to make it bootable.
The Linux image in the SD card includes the LKMs `lkm_hwtj_array64.o` and `lkm_hwtj_array1K.o` that can be used as a target for the Integrity trojan attack.
Upon loading, these LKMs allocate a space of 64 B or 1 KB inside the Kernel and print the starting address of it.
Once the LKM is loaded, running the user process `irtX_trig_array.o` (where `X` is the number of the IRT trojan loaded), will trigger the hardware trojan attack and overwrite the contents of the space allocated by the LKM.
Upon unloading, the LKM prints the first and last address of the allocated space along with their altered contents.
If the attack was successful, the contents of the addresses should have changed by the control software to the value `0xCBBBBBBBAAAAAAAD`.

5) `src`: Includes the C files of the control software for the IRT-1 and IRT-2 trojans. 
The provided Linux image includes the binary version of the control sfotware.

## Create a new IRT bitstream:
----------

With the risc-v toolchain and Vivado in `$PATH` run:

`./main.sh irtX`

where `irtX` is either `irt1` for the IRT-1 or `irt2` for the IRT-2 trojan. 

Once implementation starts, to observe its course execute:

`tail -f ./cva6/SynPnR.log`

The final `.mcs` and `.bit` files are copied in `./cva6/corev_apu/fpga/work-fpga` after the end of the implementation.

## Create an SD card:
----------

While on a Linux system, attach an SD card and execute `lsblk` to find its device name (e.g., /dev/sdX).  
Then `cd` in the `stand_alone` folder and run:

`./wr_img2sd.sh sdX` 
where `sdX` is the SD device name printed through `lsblk`.

The Linux image will be flushed in the SD card and the SD card will be ready for use with the CVA6.
The Linux image will include three LKMs for experimentation, as well as the control software for IRT1 and IRT2 trojans.

## Run the Integrity attack:
----------
Once booted inside CVA6's Linux environment, load one of the `lkm_hwtj_array64.ko` or `lkm_hwtj_array1K.ko` in the following way:

`insmod lkm_hwtj_array64.ko`

This will print the starting address `START_ADDRESS` of the allocated space in the Kernel.

To perform the attack, execute the respective `irtX_trig_array` binary providing it with the parameters `REPS` and `START_ADDRESS`:

`irt1_trig_array.o REPS START_ADDRESS`

For the 64 B space the `REPS` is equal to 8, while for the 1 KB the `REPS` is equal to 128.
The `START_ADDRESS` is the one provided upon loading of the LKM.

To view the changes on the addresses of the LKM, you need to unload it in the following way;
`rmmod lkm_hwtj_array64.ko`

For IRT-2, before the execution of the attack, the trojan needs to be enabled:
`./irt2_start_add.o`

To disable the IRT-2 trojan after the end of the attack, execute:
`./irt2_stop_add.o`

## Run the Availability attack:
----------
For the execution of the availability attack, follow the steps outlined in the integrity attack, but this time load the `lkm_hwtj_init.ko` LKM, to print the start addess if the `init_task` struct.
Use the above mentioned control software binaries and change the `REPS` to an arbitrary big number (e.g., 1000).
Executing this attack  will cause a kernel panic, making the system unresponsive.
