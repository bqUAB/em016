# DE0-Nano-SoC VGA Test
Simple VGA test using the first three dip switches of the [DE0-Nano-SoC board](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=941)
as an RGB input.

The files provided here can be used to configure the board to output VGA using
the GPIO 0.

## File Description
**vga.qsf**: quartus settings file. This file stores the pin assignments for
the Cyclone V SoC found on the DE0-Nano-SoC.

**vga-test-pinout.csv**: comma-separated values. This file stores the pinout
relationship between the DE0-Nano-SoC's GPIO 0 (JP1) and the
[DLP 2000 EVM](http://www.ti.com/tool/DLPDLCR2000EVM) GPIO (P1) which are
connected.

**vga.sof**: SRAM object file. This file is used to configure the FPGA
immediately. (Use at your own risk, provided as is)

## Dependencies
[vga_sync.vhd](../../vhdl/vga_sync.vhd)

[vga_top.vhd](../../vhdl/vga_top.vhd)
