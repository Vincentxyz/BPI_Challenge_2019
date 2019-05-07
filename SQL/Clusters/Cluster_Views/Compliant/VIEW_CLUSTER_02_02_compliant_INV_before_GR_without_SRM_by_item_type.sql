-- Split creation PROM.CLUSTER_02_02_compliant_INV_before_GR_without_SRM by item type

DROP VIEW IF EXISTS PROM.CLUSTER_02_02_01_compliant_INV_before_GR_without_SRM_Standard;
Go

DROP VIEW IF EXISTS PROM.CLUSTER_02_02_02_compliant_INV_before_GR_without_SRM_Subcontracting;
Go


CREATE VIEW PROM.CLUSTER_02_02_01_compliant_INV_before_GR_without_SRM_Standard
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '02_02'
INNER JOIN stg.case_compliance
ON Event_Log_All._case_concept_name_ = case_compliance._case_concept_name_
AND case_compliance.is_compliant = 1
WHERE Event_log_All._case_Item_Type_ = 'Standard';
Go

CREATE VIEW PROM.CLUSTER_02_02_02_compliant_INV_before_GR_without_SRM_Subcontracting
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '02_02'
INNER JOIN stg.case_compliance
ON Event_Log_All._case_concept_name_ = case_compliance._case_concept_name_
AND case_compliance.is_compliant = 1
WHERE Event_log_All._case_Item_Type_ = 'Subcontracting';
Go

DROP VIEW IF EXISTS PROM.CLUSTER_02_02_03_compliant_INV_before_GR_without_SRM_Third_Party;
Go

CREATE VIEW PROM.CLUSTER_02_02_03_compliant_INV_before_GR_without_SRM_Third_Party
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '02_02'
INNER JOIN stg.case_compliance
ON Event_Log_All._case_concept_name_ = case_compliance._case_concept_name_
AND case_compliance.is_compliant = 1
WHERE Event_log_All._case_Item_Type_ = 'Third-Party';
Go
