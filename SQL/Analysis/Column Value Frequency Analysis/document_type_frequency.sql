SELECT _case_Document_Type_,COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Document_Type_
  

SELECT _case_Item_Category_,_case_Document_Type_,COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Item_Category_, _case_Document_Type_
  ORDER BY _case_Item_Category_, _case_Document_Type_
