SELECT 
	_case_Item_Category_,
	_case_Spend_classification_text_,
	COUNT(*)
  FROM [PROM].[Multi_Invoice_Analysis]
  GROUP BY _case_Item_Category_,Invoice_Quantity
  ORDER BY _case_Item_Category_,Invoice_Quantity