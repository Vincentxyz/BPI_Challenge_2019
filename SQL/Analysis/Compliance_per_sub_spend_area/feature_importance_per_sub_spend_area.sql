SELECT _case_Sub_spend_area_text_,SUM(is_compliant)/COUNT(is_compliant)
FROM stg.case_compliance
JOIN stg.case_table_filtered
ON case_table_filtered._case_concept_name_ = case_compliance._case_concept_name_
GROUP BY _case_Sub_spend_area_text_, is_complete
HAVING is_complete = 1