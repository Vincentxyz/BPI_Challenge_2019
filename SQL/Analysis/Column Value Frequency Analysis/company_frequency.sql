SELECT _case_Company_, COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Company_