add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;

USE mitroshinde1;


DROP TABLE IF EXISTS initial_data;

CREATE TABLE initial_data
STORED AS TEXTFILE 
AS SELECT 
    content.userInn AS inn,
    content.dateTime.date/1000 as BIGINT AS transaction_ts,
    subtype
FROM all_data
SORT BY inn;


SELECT * FROM initial_data LIMIT 5;
