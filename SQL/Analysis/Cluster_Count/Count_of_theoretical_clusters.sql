SELECT _case_Item_Category_, _case_Document_Type_, _case_Item_Type_, COUNT(*) as [Count of cases]
FROM stg.case_table_filtered
GROUP BY _case_Item_Category_, _case_Document_Type_, _case_Item_Type_
ORDER BY _case_Item_Category_, _case_Document_Type_, _case_Item_Type_


SELECT case_table_filtered._case_Item_Category_, _case_Document_Type_, _case_Item_Type_, COUNT(*) as [Count of cases]
FROM stg.case_table_filtered
JOIN stg.case_compliance ON case_table_filtered._case_concept_name_ = case_compliance._case_concept_name_
AND case_compliance.is_compliant = 1
GROUP BY case_table_filtered._case_Item_Category_, _case_Document_Type_, _case_Item_Type_
ORDER BY case_table_filtered._case_Item_Category_, _case_Document_Type_, _case_Item_Type_
