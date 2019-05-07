
-- View creation of the subclusters of PROM.CLUSTER_01_02_compliant_INV_after_GR_without_SRM 

DROP VIEW IF EXISTS PROM.CLUSTER_01_02_01_compliant_INV_after_GR_without_SRM_Service;
Go

DROP VIEW IF EXISTS PROM.CLUSTER_01_02_02_compliant_INV_after_GR_without_SRM_Standard;
Go

DROP VIEW IF EXISTS PROM.CLUSTER_01_02_03_compliant_INV_after_GR_without_SRM_Subcontracting_Third_Party;
Go


CREATE VIEW PROM.CLUSTER_01_02_01_compliant_INV_after_GR_without_SRM_Service
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '01_02'
INNER JOIN stg.case_compliance
ON Event_Log_All._case_concept_name_ = case_compliance._case_concept_name_
AND case_compliance.is_compliant = 1
WHERE Event_Log_All._case_Item_Type_= 'Service';
Go

CREATE VIEW PROM.CLUSTER_01_02_02_compliant_INV_after_GR_without_SRM_Standard
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '01_02'
INNER JOIN stg.case_compliance
ON Event_Log_All._case_concept_name_ = case_compliance._case_concept_name_
AND case_compliance.is_compliant = 1
WHERE Event_Log_All._case_Item_Type_= 'Standard';
Go

CREATE VIEW PROM.CLUSTER_01_02_03_compliant_INV_after_GR_without_SRM_Subcontracting_Third_Party
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '01_02'
INNER JOIN stg.case_compliance
ON Event_Log_All._case_concept_name_ = case_compliance._case_concept_name_
AND case_compliance.is_compliant = 1
WHERE Event_Log_All._case_Item_Type_ IN ('Subcontracting', 'Third-Party');
Go



-- New


CREATE VIEW PROM.CLUSTER_01_03_01_compliant_INV_after_GR_Framework_order_Service
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '01_02'
INNER JOIN stg.case_compliance
ON Event_Log_All._case_concept_name_ = case_compliance._case_concept_name_
AND case_compliance.is_compliant = 1
WHERE Event_Log_All._case_Item_Type_= 'Service'
AND _case_Document_Type_ = 'Framework order';
Go

CREATE VIEW PROM.CLUSTER_01_02_01_compliant_INV_after_GR_Standard_PO_Service
AS SELECT  Event_Log_All.*,case_clustering.level_2_cluster_id
FROM PROM.Event_Log_All
INNER JOIN stg.case_clustering
ON Event_Log_All._case_concept_name_ = case_clustering._case_concept_name_
AND case_clustering.level_2_cluster_id like '01_02'
INNER JOIN stg.case_compliance
ON Event_Log_All._case_concept_name_ = case_compliance._case_concept_name_
AND case_compliance.is_compliant = 1
WHERE Event_Log_All._case_Item_Type_= 'Service'
AND _case_Document_Type_ = 'Standard PO';
Go
