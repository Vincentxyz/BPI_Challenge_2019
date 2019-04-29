CREATE VIEW PTP.CLUSTER_01_01_compliant_INV_after_GR_with_SRM
AS SELECT Event_Log_All.*
FROM PROM.Event_Log_All
INNER JOIN PTP.Case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id = '01-01'
INNER JOIN stg.case_compliance
ON Event_Log_All._event_concept_name_ = case_compliance._event_concept_name_
AND case_compliance.is_compliant = 1