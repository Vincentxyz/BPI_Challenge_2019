SELECT _case_source_, COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Source_