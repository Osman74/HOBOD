add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
add jar /opt/cloudera/parcels/CDH/lib/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;

SET hive.cli.print.header=false;
SET mapred.input.dir.recursive=true;
SET hive.mapred.supports.subdirectories=true;
SET ignore.malformed.json=true;

USE mitroshinde1;

DROP TABLE IF EXISTS all_data;

CREATE external TABLE all_data (
    `_id` map<string, string>,
    subtype string,
    fsId string,
    kktRegId string,
    receiveDate struct<date: string>,
    protocolVersion int, 
    ofdId string,
    protocolSubversion string,
    documentId int,
    content struct<
        user: string,
        userInn: string,
        code: int,
        fiscalDriveNumber: string,
        operator: string,
        rawData: string,
        shiftNumber: int,
        kktRegId: string,
        fiscalSign: string,
        fiscalDocumentNumber: int, 
        dateTime: struct<date: string>
    >
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/data/hive/fns2';

SELECT * FROM all_data LIMIT 50;
