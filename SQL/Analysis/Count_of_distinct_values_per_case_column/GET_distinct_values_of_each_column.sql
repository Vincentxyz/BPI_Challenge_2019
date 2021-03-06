

SELECT 
COUNT(DISTINCT case_table_filtered._case_concept_name_) AS _case_concept_name_,
COUNT(DISTINCT _case_Spend_area_text_) AS _case_Spend_area_text_,
COUNT(DISTINCT _case_Company_) AS _case_Company_,
COUNT(DISTINCT _case_Document_Type_) AS _case_Document_Type_,
COUNT(DISTINCT _case_Sub_spend_area_text_) AS _case_Sub_spend_area_text_,
COUNT(DISTINCT _case_Purchasing_Document_) AS _case_Purchasing_Document_,
COUNT(DISTINCT _case_Purch__Doc__Category_name_) AS _case_Purch__Doc__Category_name_,
COUNT(DISTINCT [_case_Vendor_]) AS [_case_Vendor_],
COUNT(DISTINCT [_case_Item_Type_]) AS [_case_Item_Type_],
COUNT(DISTINCT case_table_filtered.[_case_Item_Category_]) AS [_case_Item_Category_],
COUNT(DISTINCT [_case_Spend_classification_text_]) AS [_case_Spend_classification_text_],
COUNT(DISTINCT [_case_Source_]) AS [_case_Source_],
COUNT(DISTINCT [_case_Name_]) AS [_case_Name_],
COUNT(DISTINCT [_case_GR_Based_Inv__Verif__]) AS [_case_GR_Based_Inv__Verif__],
COUNT(DISTINCT [_case_Item_]) AS [_case_Item_],
COUNT(DISTINCT [_case_Goods_Receipt_]) AS [_case_Goods_Receipt_]
FROM stg.case_table_filtered
JOIN stg.case_compliance
ON case_table_filtered._case_concept_name_= case_compliance._case_concept_name_
AND case_compliance.is_compliant = 1
Go
