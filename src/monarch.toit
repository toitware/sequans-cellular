// Copyright (C) 2022 Toitware ApS. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import bytes
import log
import uart
import at
import gpio

import cellular
import cellular.base show *
import cellular.service show CellularServiceDefinition

import .sequans_cellular

/**
This is the driver and service for the Sequans Monarch module. The easiest
  way to use the module is to install it in a separate container and let
  it provide its network implementation as a service.

You can install the service through Jaguar:

$ jag container install cellular-monarch src/monarch.toit

and you can run the example afterwards:

$ jag run examples/monarch.toit

Happy networking!
*/
main:
  service := MonarchService
  service.install

// --------------------------------------------------------------------------

class MonarchService extends CellularServiceDefinition:
  constructor:
    super "sequans/monarch" --major=0 --minor=1 --patch=0

  create_driver --port/uart.Port --power/gpio.Pin? --reset/gpio.Pin? -> cellular.Cellular:
    // TODO(kasper): If power or reset are given, we should probably
    // throw an exception.
    return Monarch port

/**
Driver for Sequans Monarch, GSM communicating over NB-IoT & M1.
*/
class Monarch extends SequansCellular:
  constructor
      uart
      --logger=log.default:
    super uart --logger=logger --default_baud_rate=921600 --use_psm=false

  on_connected_ session/at.Session:

  on_reset session/at.Session:
