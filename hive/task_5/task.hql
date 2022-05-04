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
    FLOOR(content.dateTime.date/1000) AS transaction_ts,
    subtype
FROM all_data
WHERE content.userInn != 'NULL'
SORT BY inn, transaction_ts;


DROP TABLE IF EXISTS prev_transaction_data;

CREATE TABLE near_transaction_data
STORED AS TEXTFILE 
AS SELECT 
    inn,
    subtype, 
    transaction_ts,
    LAG(subtype) OVER (PARTITION BY inn ORDER BY transaction_ts) AS prev_transaction_type,
    LEAD(subtype) OVER (PARTITION BY inn ORDER BY transaction_ts) AS next_transaction_type
FROM initial_data;


DROP TABLE IF EXISTS data_task_5;

CREATE TABLE data_task_5
STORED AS TEXTFILE 
AS SELECT DISTINCT inn 
FROM near_transaction_data
WHERE subtype == "receipt" AND (next_transaction_type == "openShift" OR prev_transaction_type == "closeShift");

SELECT * FROM data_task_5 LIMIT 50;
