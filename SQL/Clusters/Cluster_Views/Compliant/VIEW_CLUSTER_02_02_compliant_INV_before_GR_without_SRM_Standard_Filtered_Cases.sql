CREATE VIEW PROM.CLUSTER_02_02_01_compliant_INV_before_GR_without_SRM_Standard_Filtered
AS
SELECT  * FROM PROM.CLUSTER_02_02_01_compliant_INV_before_GR_without_SRM_Standard
WHERE CLUSTER_02_02_01_compliant_INV_before_GR_without_SRM_Standard._case_concept_name_ 
NOT IN (SELECT _case_concept_name_ FROM stg.CLUSTER_02_02_01_compliant_INV_before_GR_without_SRM_Standard_Filter_Cases);
Go