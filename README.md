# riscv-hw-trojans
Hardware Trojans implemented for RISC-V designs.

## ASTRAHAN 

Astrahan is a realistic, minimal footprint, all digital hardware trojan (HT) design that targets [CVA6](https://github.com/openhwgroup/cva6), a modern, Linux-capable 64-bit RISC-V CPU design.

Astrahan targets the memory protected areas of the CPU through the store memory-access mechanism.
The HT is inserted by adjusting CVA6's Register-Transfer-Level code, however Astrahan's practical design can potentially alleviate its insertion during a fabrication stage attack.

Astrahan's capabilities have been tested on a full-system implementation of the CVA6 core on a Genesys-2 FPGA board.
The results showed that Astrahan does not interfere with normal system operation (unless triggered) and it does not otherwise exhibit obvious differences from a HT-free CVA6 CPU.

Astrahan's design files, along with the software logic necessary to operate it, will be open-sourced upon publication.  
Preliminary results can be seen in our poster presentation at [CHES 2022](https://ches.iacr.org/2022/) titled ["The Design and Implementation of an Open-Source Hardware Trojan for a 64-bit RISC-V CPU"](https://ches.iacr.org/2022/acceptedposters.php).
