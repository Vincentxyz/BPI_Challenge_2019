
-- View creation PROM.CLUSTER_01_01_compliant_INV_after_GR_with_SRM

DROP VIEW IF EXISTS PROM.CLUSTER_01_01_compliant_INV_after_GR_with_SRM;
Go

CREATE VIEW PROM.CLUSTER_01_01_compliant_INV_after_GR_with_SRM
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '01_01'
INNER JOIN stg.case_compliance
ON Event_Log_All._case_concept_name_ = case_compliance._case_concept_name_
AND case_compliance.is_compliant = 1

