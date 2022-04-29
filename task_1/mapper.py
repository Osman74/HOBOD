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
            if key in words.keys():
                if words[key] >= 0:
                    if word.istitle():
                        words[key] += 1
                    else:
                        words[key] = -1
                        
            else:
                if word.istitle():
                    words[key] = 1
                else:
                    words[key] = -1
    
    for key in words.keys():
        if words[key] > 0:
            print(key + '\t' + str(words[key]))
