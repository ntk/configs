#!/bin/bash

while true
  do
     cat /proc/cpuinfo | sed '/^.*cpu MHz.*/!d;s/^.*: \([0-9]*\).*/\1/'
     sleep 10
  done
