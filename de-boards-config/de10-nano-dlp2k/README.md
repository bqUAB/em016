DE10-Nano VGA Test
=====================

Simple VGA test using the first three dip switches of the [DE10-Nano
board](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=1046)
as an RGB input.

The files provided here can be used to configure the board to output VGA using
the GPIO 0.

## File Description
**.qsf**: quartus settings file. This file stores the pin assignments for the
Cyclone V SoC found on the DE10-Nano.

**.csv**: comma-separated values. This file stores the pinout relationship
between the DE10-Nano's GPIO 0 (JP1) and the [DLP 2000 EVM](http://www.ti.com/tool/DLPDLCR2000EVM)
GPIO (P1). Both boards are connected.

**.sof**: SRAM object file. This file is used to configure the FPGA
immediately. (Use at your own risk, provided as is)

## Dependencies
[vga_sync.vhd](../../vhdl/vga_sync.vhd)

[dlp2k.vhd](../../vhdl/vga_top.vhd)
