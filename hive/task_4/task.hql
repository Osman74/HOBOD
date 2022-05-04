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
    HOUR(from_unixtime(FLOOR(content.dateTime.date/1000))) AS payment_hour,
    NVL(content.totalSum, 0) AS profit
FROM all_data
WHERE content.userInn != 'NULL';

DROP TABLE IF EXISTS first_time;

CREATE TABLE first_time
STORED AS TEXTFILE 
AS SELECT 
    inn, 
    AVG(profit) AS avg_profit_first
FROM initial_data 
WHERE payment_hour < 13 
GROUP BY inn;

DROP TABLE IF EXISTS second_time;

CREATE TABLE second_time
STORED AS TEXTFILE 
AS SELECT 
    inn, 
    AVG(profit) AS avg_profit_second 
FROM initial_data 
WHERE payment_hour >= 13 
GROUP BY inn;

DROP TABLE IF EXISTS data_task_4;

CREATE TABLE data_task_4
STORED AS TEXTFILE 
AS SELECT 
    first_time.inn, 
    ROUND(avg_profit_first, 0) AS avg_profit_first, 
    ROUND(avg_profit_second, 0) AS avg_profit_second 
FROM first_time
INNER JOIN second_time ON first_time.inn = second_time.inn
WHERE avg_profit_first > avg_profit_second
SORT BY avg_profit_first;

SELECT * FROM data_task_4 LIMIT 50;
