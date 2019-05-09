#!/bin/bash
echo $(ps ux | grep [x]screensaver | wc -l)
