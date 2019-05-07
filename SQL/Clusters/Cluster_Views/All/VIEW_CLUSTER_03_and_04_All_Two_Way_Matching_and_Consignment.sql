
CREATE VIEW [PROM].[CLUSTERS_03_All_Two_Way_Matching]
AS 
SELECT Event_log_All.*
FROM PROM.Event_log_All
JOIN stg.case_clustering
ON Event_log_All._case_concept_name_ = case_clustering._case_concept_name_
AND level_1_cluster_id = '03'
GO

CREATE VIEW [PROM].[CLUSTERS_04_All_Consignment]
AS 
SELECT PROM.Event_log_All.*
FROM PROM.Event_log_All
JOIN stg.case_clustering
ON Event_log_All._case_concept_name_ = case_clustering._case_concept_name_
AND level_1_cluster_id = '04'
GO




