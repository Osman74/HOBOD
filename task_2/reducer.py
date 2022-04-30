#!/usr/bin/env python3

import sys

sys.stdin = open(sys.stdin.fileno(), encoding='utf-8')

current_key = None
current_date = None
sum_count = 0
for line in sys.stdin:
    try:
        date, key, count = line.strip().split('\t', 2)
        count = int(count)
    except ValueError as e:
        continue

    if current_key != key or current_date != date:
        if current_key and current_date:
            print ("{}\t{}\t{}".format(current_date, current_key, sum_count))
        sum_count = 0
        current_key = key
        current_date = date
    sum_count += count

if current_key:
    print ("{}\t{}\t{}".format(current_date, current_key, sum_count))


