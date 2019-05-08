SELECT level_1_cluster_id, is_compliant, COUNT(DISTINCT Event_Log_All._case_concept_name_)
FROM PROM.Event_Log_All
JOIN stg.case_clustering
ON Event_log_All._case_concept_name_ = case_clustering._case_concept_name_
JOIN stg.case_compliance
ON Event_log_All._case_concept_name_ = case_compliance._case_concept_name_
GROUP BY level_1_cluster_id, is_compliant
ORDER BY level_1_cluster_id, is_compliant
