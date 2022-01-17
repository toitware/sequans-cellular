// Copyright (C) 2022 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

/**
This example demonstrates how to create a Sara R4 driver and connect it to a
  cellular network.

The example resets the modem before connecting to remove any unexpected state
  before connecting. However, this makes the connection time fairly long.
*/
import cellular
import gpio
import http.client show Client
import log
import net
import uart
import sequance_cellular.monarch show Monarch

APN ::= "onomondo"
BANDS ::= [ 20, 8 ]
RATS ::= null

TX_PIN_NUM ::= 5
RX_PIN_NUM ::= 23
RTS_PIN_NUM ::= 19
CTS_PIN_NUM ::= 18

logger ::= log.default

main:
  driver := create_driver

  if not connect driver: return

  network_interface := driver.network_interface
  visit_google network_interface
  driver.close

create_driver -> Monarch:
  tx := gpio.Pin TX_PIN_NUM
  rx := gpio.Pin RX_PIN_NUM
  rts := gpio.Pin RTS_PIN_NUM
  cts := gpio.Pin CTS_PIN_NUM

  port := uart.Port --tx=tx --rx=rx --rts=rts --cts=cts --baud_rate=cellular.Cellular.DEFAULT_BAUD_RATE

  return Monarch port --logger=logger

reset driver:
  driver.wait_for_ready
  driver.reset

connect driver/cellular.Cellular -> bool:
  logger.info "WAITING FOR MODULE..."
  driver.wait_for_ready
  logger.info "model: $driver.model"
  logger.info "version $driver.version"
  logger.info "iccid: $driver.iccid"
  logger.info "CONFIGURING..."
  driver.configure APN --bands=BANDS --rats=RATS
  logger.info "ENABLING RADIO..."
  driver.enable_radio
  logger.info "CONNECTING..."
  try:
    dur := Duration.of:
      driver.connect
    logger.info "CONNECTED (in $dur)"
  finally: | is_exception exception |
    if is_exception:
      critical_do:
        driver.close
        logger.info "CONNECTION FAILED WITH '$exception'"
        return false
  return true

visit_google network_interface/net.Interface:
  host := "www.google.com"

  client := Client network_interface

  response := client.get host "/"

  bytes := 0
  while data := response.body.read:
    bytes += data.size

  logger.info "Read $bytes bytes from http://$host/"
