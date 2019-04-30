SELECT _case_Sub_spend_area_text_,COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Sub_spend_area_text_
  

SELECT _case_Sub_spend_area_text_,_case_Spend_classification_text_,COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Item_Category_, _case_Sub_spend_area_text_
  ORDER BY _case_Item_Category_, _case_Sub_spend_area_text_
