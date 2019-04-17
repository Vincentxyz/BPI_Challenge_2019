/****** Object:  View [PROM].[Event_Log_Consignment]    Script Date: 4/17/2019 2:40:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [PROM].[Event_Log_Consignment]
AS
SELECT 
case_table_Consignment.[_case_concept_name_]
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
	  ,[_event_concept_name_]
      ,[_event_User_]
      ,[_event_org_resource_]
      ,[_event_Cumulative_net_worth__EUR__]
      ,[_event_time_timestamp_]
      ,[_event_ID__]
	  ,[Sorting]

 FROM 
PTP.case_table_Consignment
JOIN PTP.event_table_Consignment
ON case_table_Consignment._case_concept_name_ = event_table_Consignment._case_concept_name_
GO


