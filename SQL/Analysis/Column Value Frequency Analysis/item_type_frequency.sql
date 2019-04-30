SELECT _case_Item_Type_,COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Item_Type_
  

SELECT _case_Item_Category_,_case_Item_Type_,COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Item_Category_, _case_Item_Type_
  ORDER BY _case_Item_Category_, _case_Item_Type_

SELECT _case_Item_Category_,_case_Item_Type_, _case_Spend_classification_text_,COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Item_Category_, _case_Spend_classification_text_,_case_Item_Type_
  ORDER BY _case_Item_Category_, _case_Spend_classification_text_,_case_Item_Type_
