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

DROP TABLE IF EXISTS table_lag;

CREATE TABLE table_lag
STORED AS TEXTFILE 
AS SELECT
    inn, 
    subtype, 
    transaction_ts, 
    Lag FROM(
        SELECT 
            inn, 
            subtype, 
            transaction_ts,
            LAG(subtype) OVER (PARTITION BY inn ORDER BY transaction_ts) as Lag 
        FROM initial_data
    ) AS inner_query
WHERE Lag != subtype;


DROP TABLE IF EXISTS result;

CREATE TABLE result
STORED AS TEXTFILE 
AS SELECT
    inn FROM (
        SELECT
            inn, 
            subtype,
            LAG(subtype) OVER (PARTITION BY inn ORDER BY transaction_ts) AS Lag,
            LEAD(subtype) OVER (PARTITION BY inn ORDER BY transaction_ts) AS Lead 
        FROM table_lag
    ) AS inner_query
WHERE subtype == "receipt" AND (Lead == "openShift" OR Lag == "closeShift");


DROP TABLE IF EXISTS data_task_5;

CREATE TABLE data_task_5
STORED AS TEXTFILE 
AS SELECT DISTINCT 
    inn FROM result;

SELECT * FROM data_task_5 LIMIT 50;
