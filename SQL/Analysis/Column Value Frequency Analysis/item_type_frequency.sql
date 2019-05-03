SELECT _case_Item_Type_,COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Item_Type_
  

SELECT _case_Item_Category_,_case_Item_Type_,COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Item_Category_, _case_Item_Type_
  ORDER BY _case_Item_Category_, _case_Item_Type_

SELECT _case_Item_Category_,_case_Item_Type_, _case_Purch__Doc__Category_name_,COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Item_Category_, _case_Purch__Doc__Category_name_,_case_Item_Type_
  ORDER BY _case_Item_Category_, _case_Purch__Doc__Category_name_,_case_Item_Type_
