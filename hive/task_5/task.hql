add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;

USE mitroshinde1;


DROP TABLE IF EXISTS initial_data;

CREATE TABLE initial_data
STORED AS TEXTFILE 
AS SELECT 
    content.userInn AS inn,
    content.dateTime.date/1000 AS transaction_ts,
    subtype
FROM all_data
WHERE content.userInn != 'NULL'
SORT BY inn;


SELECT * FROM initial_data LIMIT 5;
