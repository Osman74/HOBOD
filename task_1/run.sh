##! /usr/bin/env bash
OUT_DIR="results__111"
NUM_REDUCERS=4
hdfs dfs -rm -r -skipTrash ${OUT_DIR} > /dev/null

(yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
        -D mapreduce.job.reduces=${NUM_REDUCERS} \
        -D mapreduce.partition.keycomparator.options="-k2,2nr" \
        -files mapper.py,reducer.py \
        -mapper mapper.py \
        -reducer reducer.py \
        -input /data/wiki/en_articles \
        -output ${OUT_DIR} > /dev/null)

hdfs dfs -cat ${OUT_DIR}/part-00000 | head -10
