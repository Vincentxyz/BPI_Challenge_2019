SELECT _case_Vendor_, _case_Name_,COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Vendor_, _case_Name_
  

SELECT _case_Vendor_, _case_Name_,_case_Document_Type_,COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Vendor_, _case_Name_, _case_Document_Type_
  ORDER BY _case_Vendor_, _case_Name_, _case_Document_Type_
