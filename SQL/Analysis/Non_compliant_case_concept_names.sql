/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [_case_concept_name_]
      ,[_case_item_category_]
  FROM [stg].[case_compliance]
  WHERE is_compliant = 0