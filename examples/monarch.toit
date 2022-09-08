// Copyright (C) 2022 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

/**
This example demonstrates how to use the Monarch service and connect it to a
  cellular network.

The example resets the modem before connecting to remove any unexpected state
  before connecting. However, this makes the connection time fairly long.
*/

import http
import log
import net.cellular

main:
  config ::= {
    cellular.CONFIG_APN: "onomondo",
    cellular.CONFIG_BANDS: [20, 8],

    cellular.CONFIG_UART_TX: 5,
    cellular.CONFIG_UART_RX: 23,
    cellular.CONFIG_UART_RTS: 19,
    cellular.CONFIG_UART_CTS: 18,

    cellular.CONFIG_LOG_LEVEL: log.INFO_LEVEL,
  }

  print "Opening cellular network"
  network := cellular.open config

  try:
    client := http.Client network
    host := "www.google.com"
    response := client.get host "/"

    bytes := 0
    while data := response.body.read:
      bytes += data.size

    print "Read $bytes bytes from http://$host/ via cellular"

  finally:
    network.close
