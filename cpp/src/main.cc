#include <stdio.h>
#include <i2c.h>


int main() {
  I2cBus i2c_0(0);
  uint8_t value = i2c_0.ReadFromMem(0x53, 0x00);
  printf("The value read is: 0x%X\n", value);
  return 0;
}
