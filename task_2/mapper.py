#!/usr/bin/env python3

import string
import sys
import re

sys.stdin = open(sys.stdin.fileno(), encoding='utf-8')

for line in sys.stdin:
    line = line.strip().split()
    if len(line) > 7:
        if line[4] == "issued" and line[5] == "server" and line[6] == "command:":
            user = line[3]
            print("{}\t{}\t{}".format(user, "command", 1))
        
        if len(line) > 8:
            if line[3] == "UUID" and line[4] == "of" and line[5] == "player":
                user = line[6]
                print("{}\t{}\t{}".format(user, "session", 1))
