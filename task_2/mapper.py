#!/usr/bin/env python3

import string
import sys
import re

sys.stdin = open(sys.stdin.fileno(), encoding='utf-8')

for line in sys.stdin:
    try:
        log_line = str(line.strip()).split()
    except ValueError as e:
        continue
    if len(log_line) > 7:
        if log_line[4] == "issued" \
                and log_line[5] == "server" \
                and log_line[6] == "command:":
            date = log_line[0]
            nick = log_line[3]
            cmd_name = log_line[7].split()[0]
            date = date.strip("[]").split(".")[0]

            print("{}\t{}\t{}".format(date, cmd_name, 1))

# -D stream.num.map.output.key.fields=2 \