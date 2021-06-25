#!/bin/sh

echo "Starting unoconv listener"
/etc/init.d/unoconvd start

echo "Starting python script"
/usr/bin/python3 -u /main.py