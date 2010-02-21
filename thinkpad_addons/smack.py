#!/usr/bin/env python
#
# smack.py - stabilised percussive desktop switcher
#
# Copyright (C) 2006 Michele Campeotto <micampe@micampe.it>
# Copyright (C) 2006 Gervase Markham <gerv@gerv.net>
# Inspired by: http://blog.medallia.com/2006/05/smacbook_pro.html
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of version 2 of the GNU General Public 
# License as published by the Free Software Foundation.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, 
# USA.

# Version 1.0.1
#
# The stability algorithm tries to ensure that the desktop is only switched
# when a percussive event arrives while the laptop is otherwise stable.
#
# It does so by keeping historical data, and checking to see if the standard
# deviation is less than a certain threshold value; i.e. to see whether the
# laptop is moving. Then, it looks for a period of readings where some
# readings exceed a threshold both above and below the mean, and the
# most recent readings have the same mean and standard deviation (i.e.
# after the percussive event, the laptop returned to the same place.)
#
# In other words, it looks for this:
#         /\
# -------/  \  /-------
#            \/

import sys, re, time, math
import wnck, gtk

POS_FILE = '/sys/devices/platform/hdaps/position'
POS_RX = re.compile('^\((-?\d+),(-?\d+)\)$')

# st stands for Short Term - very recent data
# lt stands for Long Term - data over a longer period of time
# Long-term stability survey time is INTERVAL * ST_LENGTH * LT_LENGTH

INTERVAL = 0.01

ST_LENGTH = 20
ST_STDDEV_THRESHOLD = 3
ST_THRESHOLD = 10

LT_LENGTH = 6
LT_STDDEV_THRESHOLD = 3

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

def switch_to_workspace_at_right():
  global workspaces, current_ws
  current_ws = (current_ws + 1) % len(workspaces)
  workspaces[current_ws].activate(0)
  flush_events()

def switch_to_workspace_at_left():
  global workspaces, current_ws
  current_ws = (current_ws - 1) % len(workspaces)
  workspaces[current_ws].activate(0)
  flush_events()

def get_pos():
  pos = open(POS_FILE).read()
  match = POS_RX.match(pos)
  return (int(match.groups()[0]), int(match.groups()[1]))

def loop():
  # Short-term values circular buffer	
  st = []
  st_idx = 0
  
  # Long-term values circular buffer
  lt = []
  lt_idx = 0
  
  # Stability flag; used to print transition messages once only
  lt_stable = False
  
  # Populate arrays with 0 to begin with
  for i in range(ST_LENGTH):
    st.append(0)
  for j in range(LT_LENGTH):
    lt.append(0)

  while True:
    # Read values from HDAPS
    x, y = get_pos()
    
    # Put y into short-term circular buffer
    st[st_idx] = y
    
    # If long-term stable
    if stddev(lt) < LT_STDDEV_THRESHOLD:
      if lt_stable == False:
	print "Stable"
	lt_stable = True
	
      # Split st array into older and newer values
      old = []
      new = []
      for i in range(ST_LENGTH / 2):
	old.append(st[(st_idx + i + 1) % ST_LENGTH])
	new.append(st[(st_idx + i + 1 + (ST_LENGTH / 2)) % ST_LENGTH])
      
      # Add some older stable data to new array, to make sure it's gone
      # back to the same stable state rather than a new one
      for i in range((ST_LENGTH / 2) + 1, ST_LENGTH):
	new.append(lt[(lt_idx + i) % LT_LENGTH])

      # If short-term stable
      st_mean = mean(st)
      print "Max: " + str(max(old)) + " > " + str(st_mean + ST_THRESHOLD) + \
            " Min: " + str(min(old)) + " < " + str(st_mean - ST_THRESHOLD) + \
	    " SD: " + str(stddev(new)) + " < " + str(ST_STDDEV_THRESHOLD)
      if stddev(new) < ST_STDDEV_THRESHOLD:
        # Scan slightly older data for high over threshold and low under it
	st_mean = mean(st)
	max_idx = -1
	min_idx = -1
	for i in range(len(old)):
	  if (old[i] > st_mean + ST_THRESHOLD):
	    max_idx = i;
	  if (old[i] < st_mean - ST_THRESHOLD):
	    min_idx = i;
	if (max_idx != -1) and (min_idx != -1):
	  print "Smack!"
	  if (max_idx > min_idx):
            switch_to_workspace_at_right()
	  else:
            switch_to_workspace_at_left()

	  # No further smacks for a while; bias long-term stddev
	  lt[(lt_idx + LT_LENGTH - 1) % LT_LENGTH] = 10000000;
    else:
      if lt_stable == True:
        print "Unstable"
	lt_stable = False
      
    st_idx = st_idx + 1
    st_idx %= ST_LENGTH

    # If short-term buffer.index = 0, copy oldest value into long-term buffer
    # Oldest value is the one pointed to by st_idx after the increment
    # above.
    if st_idx == 0:
      lt[lt_idx] = st[st_idx]
      lt_idx = lt_idx + 1
      lt_idx %= LT_LENGTH
      print "Stability stddev: " + str(stddev(lt))

    time.sleep(INTERVAL)

def mean(values):
  # Return the arithmetic average of the values
  return sum(values) / float(len(values))

def stddev(values):
  # The standard deviation of a set of values
  meanval = mean(values)
  return math.sqrt(sum([(x - meanval)**2 for x in values]) / (len(values)-1))

def main():
  get_all_workspaces()
  try:
    loop()
  except KeyboardInterrupt:
    pass

if __name__ == '__main__':
  main()
