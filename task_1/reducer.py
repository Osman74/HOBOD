#!/usr/bin/env python
import sys

word = None
counter = 0

    
for line in sys.stdin:
    if not line:
        continue
    key, value = line.split('\t')
    key = key.strip()
    value = value.strip()
    if not key or not value:
        continue
    
    if word is None:
        word = key

    if word != key:
        if counter > 0:
            print(word + '.' + str(counter))
#             print(str(counter) + '\t' + word)
        word = key
        counter = 0

    counter += int(value)

if counter > 0:
    print(word + '.' + str(counter))
#     print(str(counter) + '\t' + word)
