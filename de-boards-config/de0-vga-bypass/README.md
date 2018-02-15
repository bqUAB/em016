# DE0 VGA Bypass
The [DE0 board](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=364)
includes a 16-pin D-SUB connector for VGA output that is going to be used for
initial testing with a standard monitor. The VGA synchronization signals are
bypassed from the GPIO 0 (J4), and a 4-bit DAC using resistor network is used
to produce the analog data signals (red, green, and blue).

The files provided here can be used to configure the DE0 board as a bypass
between the GPIO 0 and the VGA output, allowing any Intel/Altera DE boards
without VGA output to connect to the DE0's GPIO 0 to gain a VGA output.

## File Description
**vga_out.bdf**: schematic (block) design file. This file can be used with any
DE board with VGA output to achieve the same goal if you change the FPGA pinout.

**vga_out.qsf**: quartus settings file. This file stores the pin assignments
for the Cyclone III FPGA found on the DE0.

**vga_out.csv**: comma-separated values. This file stores the pinout
relationship between the DE0's GPIO 0 (J4) and the [DLP 2000 EVM](http://www.ti.com/tool/DLPDLCR2000EVM)
GPIO (P1) it tries to emulate.

**vga_out.sof**: SRAM object file. This file is used to configure the FPGA
immediately. (Use at your own risk, provided as is)

**vga_out.pof**: programmer object file. This file is used to configure the
EPCS4 EEPROM of the DE0 for non-volatile FPGA configuration storage. (Use at
your own risk, provided as is)
