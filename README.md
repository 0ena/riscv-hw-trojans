Hardware Trojans implemented for RISC-V designs.

## HOST 2024: Towards Practical Fabrication Stage Attacks Using Interrupt-Resilient Hardware Trojans
In this update we are releasing the Interrupt-Resilient Trojan design logic.
The IRTs have been tested against the [CVA6](https://github.com/openhwgroup/cva6) RISC-V micro-architecture.
The next update will include the control software, as well as pre-build bitstreams and Linux images ready to be tested.
For anyone to use this work, we kindly request you to cite our paper:

`@misc{moschos2024practical,
      title={Towards Practical Fabrication Stage Attacks Using Interrupt-Resilient Hardware Trojans}, 
      author={Athanasios Moschos and Fabian Monrose and Angelos D. Keromytis},
      year={2024},
      eprint={2403.10659},
      archivePrefix={arXiv},
      primaryClass={cs.CR}
}`

## File structure:
Design under attack: CVA6 RISC-V microarchitecture - https://github.com/openhwgroup/cva6

What's included in this deliverable version:

1) main.sh : A Bash script that downloads the CVA6 Github repo and switches the repo's HEAD to the commit we used for the generation of the hardware trojan attack.
The script creates a "DIFFs.txt" log file with the differences between the original repo RTL code and the trojan-RTL code.
The trojan-RTL code is copied to the appropriate CVA6 directories and the generation of a new trojan-CVA6 bitstream is initiated.
The final outcomes are the "ariane_xilinx.mcs" and "ariane_xilinx.bit" files that can be loaded in a Genesys2 board for testing.

IMPORTANT: We are using the tools suggested in the CVA6 repository, for the generation of the trojan-bitstream.
Therefore, for the Bash script to work correctly, it is assumed that a user has followed the steps described in the CVA6's repository guide to install the risc-v toolchain.
Bofore running the Bash script, both the risc-v toolchain and Xilinx's Vivado should be in $PATH.

2) ./irt_rtl : This folder contains the RTL code of the IRT-1 and IRT-2 trojans, as well as the necessary modifications to the rest of the CVA6 logic.

## Create a bitstream:
----------

With the risc-v toolchain and Vivado in the $PATH just run:

`./main.sh irtX`

where irtX is either "irt1" for the IRT-1 or "irt2" for the IRT-2 trojan. 

Once Implementation starts, to observe its course execute:

`tail -f ./cva6/SynPnR.log`

The final .mcs and .bit files are copied in "./cva6/corev_apu/fpga/work-fpga" after the end of the implementation.

## Create an SD card:
----------
To be released in the next repository update.

## Run the Integrity experiment:
----------
To be released in the next repository update.

## Run the Availability experiment:
----------
To be released in the next repository update.
