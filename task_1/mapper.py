#!/usr/bin/env python
import sys
import re


pattern = re.compile("^[A-Z][a-z]+$")
words = dict()

for text in sys.stdin:
    article_id, line = text.strip().split('\t', 1)
    words = dict()
    line = line.strip()
    word_pattern = "\w+"
    for word in re.finditer(word_pattern, line):
        word = word.group()
        key = word.lower()
        if 6 <= len(key) <= 9:
            value = words.get(key, None)
            if value is not None:
                if value >= 0:
                    if pattern.match(word):
                        words[key] += 1
                    else:
                        words[key] = -1
                        
            else:
                if pattern.match(word):
                    words[key] = 1
                else:
                    words[key] = -1

    for key, value in words.items():
        if value > 0:
            print(key + '\t' + str(value))
