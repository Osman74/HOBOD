#!/usr/bin/env python3

import sys

sys.stdin = open(sys.stdin.fileno(), encoding='utf-8')

commands = 0
sessions = 0
cur_user = None
for line in sys.stdin:
    if not line.strip():
        continue
    user, action, value = line.strip().split('\t', 2)
    value = int(value)
    
    if cur_user is None:
        cur_user = user

    if cur_user != user:
        if sessions >= 0:
            print("{}\t{}\t{}".format(cur_user, round(commands / max(sessions, 1), 0), sessions))
        sessions = 0
        commands = 0
        cur_user = user
    if action == "command":
        commands += value
    else:
        sessions += value

if sessions >= 0:
    print("{}\t{}\t{}".format(cur_user, round(commands / max(sessions, 1), 0), sessions))
