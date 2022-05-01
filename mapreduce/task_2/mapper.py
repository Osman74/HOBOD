#!/usr/bin/env python3

import string
import sys
import re

# sys.stdin = open(sys.stdin.fileno(), encoding='utf-8')

for line in sys.stdin:
    line = line.strip().split()
    if len(line) > 7:
        if line[4] == "issued" and line[5] == "server" and line[6] == "command:":
            user = line[3]
            print("{}\t{}\t{}".format(user, "command", 1))
        
        if line[2] == "UUID" and line[3] == "of" and line[4] == "player":
            user = line[5]
            print("{}\t{}\t{}".format(user, "session", 1))
