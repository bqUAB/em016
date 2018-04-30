#include <stdio.h>
#include <i2c.h>
#include <dlpc2607.h>


int main() {
  I2cBus i2c_bus(1);
  Dlpc2607 dlp(&i2c_bus);
  // Initialization of the DLP
  if (dlp.Init()) {
    printf("DLP Initialization Successful!\n");
  }

  return 0;
}
