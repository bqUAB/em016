// ***************************************************************************
// Source file for the DLPC2607 class
// by Byron Quezada
//
// This class was implemented for a DLPC2607 coupled with a DLP2000 found on
// the DLP LightCrafter Display 2000 EVM.
// Basic functionality
//
// Created on 10 April 2018
// ***************************************************************************

#include <dlpc2607.h>


// Dlpc2607 constructor
Dlpc2607::Dlpc2607(I2cBus* i2c_n) {
  ptr_i2c = i2c_n;
}

bool Dlpc2607::DmdPark(bool park) {
  bool success = 0;
  uint8_t value[4] = {0, 0, 0, park};

  success = ptr_i2c->WriteToMemFrom(kDlpc2607Addr, kDmdParkCtrl, 4, value);

  return success;
}

bool Dlpc2607::SoftRst() {
  // Bit value is don't care so a 1 or 0 can be issued.
  // Prior to issuing a software reset command, TI recommends that a DMD PARK
  // (I2C: 0x2D) command be applied first, followed by a 500-μs wait interval
  // before issuing the reset.
  bool success = 0;
  uint8_t value[4] = {0, 0, 0, true};

  success = ptr_i2c->WriteToMemFrom(kDlpc2607Addr, kSoftRst, 4, value);

  return success;
}

bool Dlpc2607::InSrcSel(uint8_t source) {
  // Input Source Selection
  bool success = 0;
  uint8_t value[4] = {0, 0, 0, source};

  success = ptr_i2c->WriteToMemFrom(kDlpc2607Addr, kInSrcSel, 4, value);

  return success;
}

bool Dlpc2607::InResSel(uint8_t resolution) {
  // Input Resolution Select
  bool success = 0;
  uint8_t value[4] = {0, 0, 0, resolution};

  success = ptr_i2c->WriteToMemFrom(kDlpc2607Addr, kInResSel, 4, value);

  return success;
}

bool Dlpc2607::PxDataFmtSel(uint8_t format) {
  // Pixel Data Format Select
  bool success = 0;
  uint8_t value[4] = {0, 0, 0, format};

  success = ptr_i2c->WriteToMemFrom(kDlpc2607Addr, kPxDataFmtSel, 4, value);

  return success;
}

bool Dlpc2607::RgbLedDrvEn(bool red, bool green, bool blue) {
  uint8_t value[4] = {0};
  bool rgb[3] = {red, green, blue};
  bool success = 0;

  for (int i = 0; i < 3; i++) {
    if (rgb[i]) {
      value[3] |= 1 << i;
    } else {
      value[3] |= 0 << i;
    }
  }

  success = ptr_i2c->WriteToMemFrom(kDlpc2607Addr, kRgbLedDrvEn, 4, value);

  return success;
}

bool Dlpc2607::Init() {
  bool success = false;

  // A DMD PARK is recommended before a Software Reset.
  success = DmdPark(true);

  if (success) {
    // Recommended time to sleep
    int microsec = 500;  // in microsenconds
    struct timespec req = {0};
    req.tv_sec = 0;
    req.tv_nsec = microsec * 1000L;
    nanosleep(&req, (struct timespec *)NULL);

    // Software Reset
    success = SoftRst();
    sleep(1);
    success = DmdPark(false);
  }

  // Input source selection
  if (success) {
    success = InSrcSel(in_src);
  }

  // Input resolution select
  if (success) {
    success = InResSel(in_res);
  }

  // Pixel data format select
  if (success) {
    success = PxDataFmtSel(px_data_fmt);
  }

  // RGB LED driver enables
  if (success) {
    success = RgbLedDrvEn(true, true, true);
  }

  return success;
}
