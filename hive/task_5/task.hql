add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;

USE mitroshinde1;


DROP TABLE IF EXISTS initial_data;

CREATE TABLE initial_data
STORED AS TEXTFILE 
AS SELECT 
    content.userInn AS inn,
    --content.dateTime.date as timestamp, 
    FLOOR(content.dateTime.date/1000) AS transaction_ts,
    subtype
    --from_unixtime(FLOOR(content.dateTime.date/1000)) as payment_date
FROM all_data
SORT BY inn, transaction_ts;


SELECT * FROM initial_data LIMIT 5;
