#!/usr/bin/python
from __future__ import print_function
import subprocess

screensaverEnabled = int(
  subprocess.check_output(['/bin/bash','-c','~/.xmonad/lockscript.sh']).strip(" \n\r")
) == 1

alert_colour = "<fc=#FF0000>"
normal_colour = "<fc=#CCC>"
end_colour = "</fc>"

colour = screensaverEnabled and normal_colour or alert_colour
mode = screensaverEnabled and "Lockscreen on." or "RED LIGHTS. NOOT NOOT. LOCKSCREEN IS OFF. NOOT NOOT. BEEP BEEP."
print(colour + " " + mode + end_colour, end="")
