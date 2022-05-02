add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
add jar /opt/cloudera/parcels/CDH/lib/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;

SET hive.cli.print.header=false;
SET mapred.input.dir.recursive=true;
SET hive.mapred.supports.subdirectories=true;

USE mitroshinde1;

DROP TABLE IF EXISTS filtered;

CREATE TABLE filtered
STORED AS TEXTFILE 
AS SELECT content.userInn,
content.dateTime.date as timestamp, 
    DAY(cast(from_unixtime(CAST(content.dateTime.date/1000 as BIGINT), 'yyyy-MM-dd') as Date )) as date_col,
    NVL(content.totalSum, 0) as totalSum from all_data;

DROP TABLE IF EXISTS summed;

CREATE TABLE summed
STORED AS TEXTFILE 
AS SELECT userInn, date_col, sum(totalSum) as sum,
row_number() over (partition by userInn order by sum(totalSum) desc) as seqnum FROM filtered
where userInn != 'NULL'
GROUP BY userInn, date_col;

DROP TABLE IF EXISTS new_data;

CREATE TABLE new_data
STORED AS TEXTFILE
AS SELECT userInn, date_col, sum from summed 
where seqnum = 1 and userInn != 'NULL';

select * from new_data LIMIT 50;
