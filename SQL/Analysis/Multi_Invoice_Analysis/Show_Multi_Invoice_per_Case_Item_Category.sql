SELECT 
	_case_Item_Category_,
	Invoice_Quantity,
	COUNT(*)
  FROM [PROM].[Multi_Invoice_Analysis]
  GROUP BY _case_Item_Category_,Invoice_Quantity
  ORDER BY _case_Item_Category_,Invoice_Quantity