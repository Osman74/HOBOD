add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;

USE mitroshinde1;


DROP TABLE IF EXISTS initial_data;

CREATE TABLE initial_data
STORED AS TEXTFILE 
AS SELECT 
    content.userInn AS inn,
    --content.dateTime.date as timestamp, 
    CAST(content.dateTime.date/1000 as BIGINT) AS timestamp,
    subtype
    --from_unixtime(FLOOR(content.dateTime.date/1000)) as payment_date
FROM all_data
SORT BY content.userInn, content.dateTime.date;

DROP TABLE IF EXISTS table_lag;

CREATE TABLE table_lag
STORED AS TEXTFILE 
AS SELECT
    inn, 
    subtype, 
    timestamp, 
    Lag FROM(
        SELECT 
            inn, 
            subtype, 
            timestamp,
            LAG(subtype) OVER (PARTITION BY inn ORDER BY timestamp) as Lag 
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
            LAG(subtype) OVER (PARTITION BY inn ORDER BY timestamp) AS Lag,
            LEAD(subtype) OVER (PARTITION BY inn ORDER BY timestamp) AS Lead 
        FROM table_lag
    ) AS inner_query
WHERE subtype == "receipt" AND (Lead == "openShift" OR Lag == "closeShift");


DROP TABLE IF EXISTS data_task_5;

CREATE TABLE data_task_5
STORED AS TEXTFILE 
AS SELECT DISTINCT 
    inn FROM result;

SELECT * FROM data_task_5 LIMIT 50;
