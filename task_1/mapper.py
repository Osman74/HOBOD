#!/usr/bin/env python
import sys
import re


pattern = re.compile("^[A-Z][a-z]+$")
words = dict()

for text in sys.stdin:
    article_id, line = text.strip().split('\t', 1)
    line = line.strip()
    word_pattern = "\w+"
    for word in re.finditer(word_pattern, line):
        word = word.group()
        key = word.lower()
        if 6 <= len(key) <= 9:
            if key not in words.keys():
                words[key] = []
            words[key].append(word)
    
    for key in words.keys():
        counter = 0
        arr = words[key]
        for word in arr:
            if pattern.match(word):
                counter += 1
            else:
                counter = 0
                break
        if counter > 0:
            print(key + '\t' + str(counter))
