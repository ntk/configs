#!/usr/bin/env python
# (c) 2006 Michele Campeotto <micampe@micampe.it>, GPLv2
# inspired from: http://blog.medallia.com/2006/05/smacbook_pro.html

import sys, re, time
import wnck, gtk

INTERVAL = 0.01
POS_FILE = '/sys/devices/platform/hdaps/position'
CAL_FILE = '/sys/devices/platform/hdaps/calibrate'
POS_RX = re.compile('^\((-?\d+),(-?\d+)\)$')
SENS = 4

workspaces = None
current_ws = None

def flush_events():
  while gtk.events_pending():
    gtk.main_iteration()

def get_all_workspaces():
  global workspaces, current_ws
  scr = wnck.screen_get_default()
  flush_events()
  current_ws = scr.get_active_workspace().get_number()
  workspaces = []
  for i in range(scr.get_workspace_count()):
    workspaces.append(scr.get_workspace(i))

def switch_to_workspace_n(n):
  global workspaces
  workspaces[n].activate(0)
  flush_events()

def swicth_to_workspace_at_right():
  global workspaces, current_ws
  current_ws = (current_ws + 1) % len(workspaces)
  workspaces[current_ws].activate(0)
  flush_events()

def swicth_to_workspace_at_left():
  global workspaces, current_ws
  current_ws = (current_ws - 1) % len(workspaces)
  workspaces[current_ws].activate(0)
  flush_events()

def get_pos():
    pos = open(POS_FILE).read()
    match = POS_RX.match(pos)
    return (int(match.groups()[0]), int(match.groups()[1]))

def get_calibration():
    pos = open(CAL_FILE).read()
    match = POS_RX.match(pos)
    return (int(match.groups()[0]), int(match.groups()[1]))

def loop():
  calx, caly = get_calibration()
  stable = 0
  while True:
    x, y = get_pos()
    if x == 0: continue
    delta = x - calx
    adelta = abs(delta)
    if adelta < 5:
      stable += 1
    if adelta > SENS and stable > 30:
      stable = 0
      if delta < 0:
        swicth_to_workspace_at_right()
#        print '->', adelta
      else:
        swicth_to_workspace_at_left()
#        print '<-', adelta
    time.sleep(INTERVAL)

def main():
  get_all_workspaces()
  try:
    loop()
  except KeyboardInterrupt:
    pass

if __name__ == '__main__':
  main()
