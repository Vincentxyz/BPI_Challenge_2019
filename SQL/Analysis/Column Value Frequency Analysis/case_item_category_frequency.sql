SELECT _case_Item_Category_,COUNT(*) AS Count_Cases
  FROM [stg].[case_table_filtered]
  GROUP BY _case_Item_Category_
  