CREATE VIEW PTP.CLUSTER_01_02_INV_after_GR_without_SRM
AS SELECT Event_Log_All.*
FROM PROM.Event_Log_All
INNER JOIN PTP.Case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
WHERE case_clustering.cluster_id = '01-02'