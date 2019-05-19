/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Deviation, COUNT(*)
  FROM [stg].[case_compliance]
  WHERE is_compliant = 0
  AND is_complete = 1
  GROUP BY Deviation