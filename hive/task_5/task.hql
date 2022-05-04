add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;

USE mitroshinde1;


DROP TABLE IF EXISTS initial_data;

CREATE TABLE initial_data
STORED AS TEXTFILE 
AS SELECT 
    content.userInn AS inn,
    subtype,
    content.dateTime.date as timestamp, 
    from_unixtime(floor(content.dateTime.date/1000)) as date_col
FROM all_data
sort by userInn, timestamp;

DROP TABLE IF EXISTS table_lag;

CREATE TABLE table_lag
STORED AS TEXTFILE 
as select userInn, subtype, timestamp, Lag from(
    select userInn, subtype, timestamp,
    LAG(subtype) OVER(PARTITION BY userInn ORDER BY timestamp) as Lag 
    from filtered_2) as inner_query
where  Lag != subtype;


DROP TABLE IF EXISTS result;

CREATE TABLE result
STORED AS TEXTFILE 
as select userInn from (
    select userInn, subtype,
    LAG(subtype) OVER(PARTITION BY userInn ORDER BY timestamp) as Lag,
    LEAD(subtype) OVER(PARTITION BY userInn ORDER BY timestamp) as Lead 
    from table_lag
) as inner_query
where subtype == "receipt" and (Lead == "openShift" or Lag == "closeShift");


DROP TABLE IF EXISTS final;

CREATE TABLE final
STORED AS TEXTFILE 
as select userInn from (
select row_number() over (partition by userInn order by userInn) as rowNum, userInn from result
) q where rowNum == 1

SELECT * FROM data_task_4 LIMIT 50;
