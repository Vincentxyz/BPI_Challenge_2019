DROP TABLE IF EXISTS PROM.Event_log_All;
Go

CREATE TABLE PROM.Event_log_All (
	"_case_concept_name_" NVARCHAR(100)
	,	"_case_Spend_area_text_" NVARCHAR(100)
	,	"_case_Company_" NVARCHAR(100)
	,	"_case_Document_Type_" NVARCHAR(100)
	,	"_case_Sub_spend_area_text_" NVARCHAR(100)
	,	"_case_Purchasing_Document_" NVARCHAR(100)
	,	"_case_Purch__Doc__Category_name_" NVARCHAR(100)
	,	"_case_Vendor_" NVARCHAR(100)
	,	"_case_Item_Type_" NVARCHAR(100)
	,	"_case_Item_Category_" NVARCHAR(100)
	,	"_case_Spend_classification_text_" NVARCHAR(100)
	,	"_case_Source_" NVARCHAR(100)
	,	"_case_Name_" NVARCHAR(100)
	,	"_case_GR_Based_Inv__Verif__" NVARCHAR(100)
	,	"_case_Item_" NVARCHAR(100)
	,	"_case_Goods_Receipt_" NVARCHAR(100)
	,  "_event_concept_name_" NVARCHAR(100)
    ,  "_event_User_" NVARCHAR(100)
    ,  "_event_org_resource_" NVARCHAR(100)
    ,  "_event_Cumulative_net_worth__EUR__" NUMERIC(15,5)
    ,  "_event_time_timestamp_" DATETIME
	,  "_event_ID__" NVARCHAR(100)
	,  "sorting" INT
);
Go




CREATE INDEX idx_event_log_all

ON PROM.Event_log_All (_case_concept_name_, _event_concept_name_, _event_time_timestamp_)

CREATE INDEX idx_event_log_all_event_id

ON PROM.Event_log_All (_event_ID__)


INSERT INTO PROM.Event_Log_All
SELECT 
case_table.[_case_concept_name_]
      ,[_case_Spend_area_text_]
      ,[_case_Company_]
      ,[_case_Document_Type_]
      ,[_case_Sub_spend_area_text_]
      ,[_case_Purchasing_Document_]
      ,[_case_Purch__Doc__Category_name_]
      ,[_case_Vendor_]
      ,[_case_Item_Type_]
      ,[_case_Item_Category_]
      ,[_case_Spend_classification_text_]
      ,[_case_Source_]
      ,[_case_Name_]
      ,[_case_GR_Based_Inv__Verif__]
      ,[_case_Item_]
      ,[_case_Goods_Receipt_]
	  ,event_table.[_event_concept_name_]
      ,[_event_User_]
      ,[_event_org_resource_]
      ,[_event_Cumulative_net_worth__EUR__]
      ,[_event_time_timestamp_]
      ,[_eventID__]
	  ,CONVERT(INT,[sorting]) AS sorting

 FROM 
stg.case_table
JOIN stg.event_table
ON case_table._case_concept_name_ = event_table._case_concept_name_
JOIN stg.Event_Sorting
ON event_table._event_concept_name_ = Event_Sorting._event_concept_name_
WHERE case_table._case_concept_name_ NOT IN 
(SELECT DISTINCT _case_concept_name_ FROM stg.excluded_cases)