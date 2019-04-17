CREATE VIEW PTP.CLUSTER_02_01_INV_before_GR_with_SRM
AS SELECT Event_Log_All.*
FROM PROM.Event_Log_All
INNER JOIN PTP.Case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
WHERE case_clustering.cluster_id = '02-01'