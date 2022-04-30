##! /usr/bin/env bash
OUT_DIR="results__123"
NUM_REDUCERS=1
hdfs dfs -rm -r -skipTrash ${OUT_DIR} > /dev/null

(yarn jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar \
        -D mapreduce.job.reduces=${NUM_REDUCERS} \
        -files mapper.py,reducer.py \
        -mapper mapper.py \
        -reducer reducer.py \
        -input /data/minecraft-server-logs \
        -output ${OUT_DIR} > /dev/null)

hdfs dfs -cat ${OUT_DIR}/part-00000 | sort -k2nr | head -10
