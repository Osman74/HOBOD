add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
add jar /opt/cloudera/parcels/CDH/lib/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;

SET hive.cli.print.header=false;
SET mapred.input.dir.recursive=true;
SET hive.mapred.supports.subdirectories=true;

USE mitroshinde;

DROP TABLE IF EXISTS all_data;

CREATE external TABLE all_data (
    `_id` map<string, string>,
    subtype string,
    fsId string,
    kktRegId string,
    receiveDate map<string, string>,
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
        dateTime: map<string, string>
    >
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/data/hive/fns2';

SELECT * FROM all_data LIMIT 50;
