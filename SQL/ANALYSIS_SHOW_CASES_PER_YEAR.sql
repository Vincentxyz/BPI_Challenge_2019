/****** Script for SelectTopNRows command from SSMS  ******/
SELECT YEAR(_event_time_timestamp_),
COUNT(*)
  FROM [stg].[event_table]
  GROUP BY YEAR(_event_time_timestamp_)
  ORDER BY YEAR(_event_time_timestamp_)