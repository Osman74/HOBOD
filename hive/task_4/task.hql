add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
add jar /opt/cloudera/parcels/CDH/lib/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;

SET hive.cli.print.header=false;
SET mapred.input.dir.recursive=true;
SET hive.mapred.supports.subdirectories=true;

USE mitroshinde1;

DROP TABLE IF EXISTS initial_data;

CREATE TABLE filtered
STORED AS TEXTFILE 
AS SELECT 
    content.userInn AS inn,
    HOUR(from_unixtime(floor(content.dateTime.date/1000))) AS date_col,
    NVL(content.totalSum, 0) AS profit 
FROM all_data;

DROP TABLE IF EXISTS first_time;

CREATE TABLE first_time
STORED AS TEXTFILE 
as select inn, avg(totalSum) AS avg_morning 
FROM initial_data 
WHERE date_col < 13 
GROUP BY inn;

DROP TABLE IF EXISTS second_time;

CREATE TABLE second_time
STORED AS TEXTFILE 
as select inn, avg(totalSum) AS avg_evening 
FROM initial_data 
WHERE date_col >= 13 
GROUP BY inn;

DROP TABLE IF EXISTS data_task_4;

CREATE TABLE data_task_4
STORED AS TEXTFILE 
as select morning.inn, avg_morning, avg_evening from first_time
inner join evening on first_time.inn = second_time.userInn
WHERE avg_morning > avg_evening
SORT BY avg_morning;

SELECT * FROM data_task_4 LIMIT 20;
