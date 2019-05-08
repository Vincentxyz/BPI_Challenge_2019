SELECT Event_Log_All._case_concept_name_, _event_concept_name_, _event_time_timestamp_, sorting
FROM PROM.Event_Log_All
JOIN stg.case_clustering
ON Event_log_All._case_concept_name_ = case_clustering._case_concept_name_
AND final_cluster = '01_01_01'
JOIN stg.case_compliance
ON Event_log_All._case_concept_name_ = case_compliance._case_concept_name_
AND is_compliant = 1
