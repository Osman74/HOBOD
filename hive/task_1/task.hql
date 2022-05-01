add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
add jar /opt/cloudera/parcels/CDH/lib/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;

SET hive.cli.print.header=false;
SET mapred.input.dir.recursive=true;
SET hive.mapred.supports.subdirectories=true;

USE mitroshinde;

DROP TABLE IF EXISTS task;

CREATE external TABLE task (
    `_id` map<string, string>,
    fsId string,
    kktRegId  string, 
    subtype  string, 
    receiveDate  map<string, string >,
    protocolVersion  int, 
    ofdId  string, 
    protocolSubversion  string,
    content struct<
        fiscalDriveNumber: string,
        operator: string,
        rawData: string,
        shiftNumber: int,
        user:  string, 
        kktRegId:  string,
        userInn:  string, 
        fiscalSign: string, 
        fiscalDocumentNumber: int, 
        code:  int,
        dateTime : map<string, string>
        >,
    documentId int
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/data/hive/fns2';

select * from task fetch first 50 rows only;
