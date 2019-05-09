#!/usr/bin/python
from __future__ import print_function
import subprocess
import re

selfname = subprocess.check_output(['whoami']).strip(" \n\r")
users = []
terms = 0

for line in subprocess.check_output(['who']).split('\n'):
    if line != "":
        users.append(line.split())

        if line[0:len(selfname)] != selfname:
          terms += 1

alert_colour = "<fc=#FF0000>"
normal_colour = "<fc=#CCC>"
end_colour = "</fc>"

finger_re = re.compile("(Name: )([a-zA-Z ]+)")

print(normal_colour + " (" + str(terms) + ")" + end_colour, end="")
for user in users:
    if user[0] == selfname:
        #print(normal_colour + " " + user[-1:][0] + end_colour + "    ", end="")
        pass
    else:
        try:
            actual_name = finger_re.search(subprocess.check_output(['finger',user[0]]))\
                                   .group(2)\
                                   .lower()\
                                   .replace(' ','')
        except Exception:
            actaul_name = user[0]
        print(alert_colour + " -- " + 
              actual_name + "@" + 
              user[-1:][0] + #.split('.')[0][1:] +
              end_colour, end="")

