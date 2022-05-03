add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
add jar /opt/cloudera/parcels/CDH/lib/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;

SET hive.cli.print.header=false;
SET mapred.input.dir.recursive=true;
SET hive.mapred.supports.subdirectories=true;

USE mitroshinde1;

DROP TABLE IF EXISTS initial_data;

CREATE TABLE initial_data
STORED AS TEXTFILE 
AS SELECT 
    content.userInn AS inn,
    DAY(CAST(from_unixtime(CAST(content.dateTime.date/1000 as BIGINT), 'yyyy-MM-dd') as Date )) as payment_date,
    content.totalSum 
FROM all_data
WHERE inn != 'NULL' AND totalSum != 'NULL';

DROP TABLE IF EXISTS sum_data;

CREATE TABLE sum_data
STORED AS TEXTFILE 
AS SELECT inn, payment_date, sum(totalSum) as sum,
row_number() over (PARTITION BY inn ORDER BY sum(totalSum) desc) AS seqnum FROM initial_data
GROUP BY inn, payment_date;

DROP TABLE IF EXISTS data_task_3;

CREATE TABLE data_task_3
STORED AS TEXTFILE
AS SELECT inn, payment_date, sum from sum_data 
WHERE seqnum = 1;

SELECT * FROM data_task_3 LIMIT 50;
