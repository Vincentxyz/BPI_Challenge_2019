
-- Split PROM.CLUSTER_01_01_ALL_INV_after_GR_with_SRM

CREATE VIEW PROM.CLUSTER_01_01_01_ALL_INV_after_GR_with_SRM_Service
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '01-01'
WHERE Event_log_All._case_Item_Type_ = 'Service';
Go

CREATE VIEW PROM.CLUSTER_01_01_02_ALL_INV_after_GR_with_SRM_Standard
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '01-01'
WHERE Event_log_All._case_Item_Type_ = 'Standard';
Go
