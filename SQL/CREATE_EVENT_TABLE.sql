USE ProMi;
Go

CREATE TABLE stg.event_table (
	"_case_concept_name_" NVARCHAR(100)
	,  "_event_concept_name_" NVARCHAR(100)
    ,  "_event_User_" NVARCHAR(100)
    ,  "_event_org_resource_" NVARCHAR(100)
    ,  "_event_Cumulative_net_worth__EUR__" NUMERIC(15,5)
    ,  "_event_time_timestamp_" DATETIME
	,  "_eventID__" NVARCHAR(100)
);
Go

CREATE INDEX ix_event_table ON stg.event_table (_case_concept_name_);
Go

INSERT INTO stg.event_table 
SELECT 
_case_concept_name_,
_event_concept_name_,
_event_user_,
_event_org_resource_,
CONVERT(NUMERIC(15,5),_event_Cumulative_net_worth__EUR__),
CONVERT(DATETIME,
SUBSTRING(_event_time_timestamp_,7,4) + '-' +
SUBSTRING(_event_time_timestamp_,4,2) + '-' +
SUBSTRING(_event_time_timestamp_,1,2) +
SUBSTRING(_event_time_timestamp_,11,13)),
_eventID__

FROM [dbo].[OriginData]