/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [eventID]
      ,[case_concept_name]
      ,[case_Goods_Receipt]
      ,[event_User]
      ,[event_org_resource]
      ,[event_concept_name]
      ,[event_cumulative_net_worth]
      ,[event_time_timestamp]
  FROM [DataModel_T01].[dbo].[BPI_Final]
  where case_concept_name in ('4507001443_00010',
'4507004992_00010',
'4507025265_00010',
'4507004992_00010',
'4507021324_00010',
'4507031352_00010',
'4507003790_00010',
'2000033515_00001',
'4507036721_00010',
'4507041713_00040',
'4507003790_00010',
'2000052735_00001',
'4507004991_00010')
order by eventID