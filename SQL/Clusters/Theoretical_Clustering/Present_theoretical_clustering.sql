SELECT case_table_filtered._case_item_Category_, _case_Document_Type_, _case_Item_Type_, COUNT(*) AS [Count of cases]
FROM stg.case_table_filtered
JOIN stg.case_clustering_theoretical
ON case_table_filtered._case_concept_name_ = case_clustering_theoretical._case_concept_name_
JOIN stg.case_compliance
ON case_table_filtered._case_concept_name_ = case_compliance._case_concept_name_
AND is_compliant = 1
GROUP BY case_table_filtered._case_item_Category_, _case_Document_Type_, _case_Item_Type_
ORDER BY case_table_filtered._case_item_Category_, _case_Document_Type_, _case_Item_Type_