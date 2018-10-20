#!/usr/bin/env python

import sys
from pyaxidraw import axidraw

# Initialize and connect to AxiDraw
ad = axidraw.AxiDraw();
ad.interactive();
connected = ad.connect();

if not connected:
	print 'Could not connect to AxiDraw. Is it plugged in and connected?';
	sys.exit();

# Get the command to run
command = sys.argv[1];

# Run command
if command == 'raise-pen':
	ad.penup()
if command == 'lower-pen':
	ad.pendown()
if command == 'reset':
	ad.penup()
	ad.goto(0,0)

# Clean up
ad.disconnect();
