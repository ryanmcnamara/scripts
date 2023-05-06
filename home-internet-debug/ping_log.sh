#!/bin/sh

DEST=8.8.8.8
LOG=~/.home-internet-debug/output
TIMEOUT_MS=1000

ping -t $DEST -w $TIMEOUT_MS | ts >> $LOG
