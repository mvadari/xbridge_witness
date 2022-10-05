#!/bin/bash

CONF="${1:-"/opt/xbridge-witness/cfg/example-config.json"}"

/opt/xbridge-witness/xbridge_witnessd --config "${CONF}"
