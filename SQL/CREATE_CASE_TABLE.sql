USE ProMi;
Go

CREATE TABLE stg.case_table (
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
);
Go

CREATE INDEX ix_case_table ON stg.case_table (_case_concept_name_);
Go

INSERT INTO stg.case_table
SELECT DISTINCT 
	[_case_concept_name_]
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
FROM [dbo].[OriginData];
Go