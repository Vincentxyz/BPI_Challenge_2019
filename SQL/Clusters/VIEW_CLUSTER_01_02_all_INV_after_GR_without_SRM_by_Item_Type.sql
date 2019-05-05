
-- View creation of the subclusters of PROM.CLUSTER_01_02_ALL_INV_after_GR_without_SRM 
DROP VIEW IF EXISTS PROM.CLUSTER_01_02_01_ALL_INV_after_GR_without_SRM_Service;
Go

DROP VIEW IF EXISTS PROM.CLUSTER_01_02_02_ALL_INV_after_GR_without_SRM_Standard;
Go

DROP VIEW IF EXISTS PROM.CLUSTER_01_02_03_ALL_INV_after_GR_without_SRM_Subcontracting;
Go

DROP VIEW IF EXISTS PROM.CLUSTER_01_02_04_ALL_INV_after_GR_without_SRM_Third_Party;
Go

DROP VIEW IF EXISTS PROM.CLUSTER_01_02_03_ALL_INV_after_GR_without_SRM_Subcontracting_Third_Party;
Go

CREATE VIEW PROM.CLUSTER_01_02_01_ALL_INV_after_GR_without_SRM_Service
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '01_02'
WHERE Event_Log_All._case_Item_Type_= 'Service';
Go

CREATE VIEW PROM.CLUSTER_01_02_02_ALL_INV_after_GR_without_SRM_Standard
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '01_02'
WHERE Event_Log_All._case_Item_Type_= 'Standard';
Go

CREATE VIEW PROM.CLUSTER_01_02_03_ALL_INV_after_GR_without_SRM_Subcontracting
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '01_02'
WHERE Event_Log_All._case_Item_Type_= 'Subcontracting';
Go

CREATE VIEW PROM.CLUSTER_01_02_04_ALL_INV_after_GR_without_SRM_Third_Party
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '01_02'
WHERE Event_Log_All._case_Item_Type_= 'Third-Party';
Go

CREATE VIEW PROM.CLUSTER_01_02_03_ALL_INV_after_GR_without_SRM_Subcontracting_Third_Party
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '01_02'
WHERE Event_Log_All._case_Item_Type_ IN ('Subcontracting', 'Third-Party');
Go