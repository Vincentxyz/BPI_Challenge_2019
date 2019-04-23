/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW PTP.CLUSTERS_04_Consignment
AS 
SELECT PTP.case_table.*, case_clustering.level_2_cluster_id
FROM PTP.case_table
JOIN PTP.case_clustering
ON case_table._case_concept_name_ = case_clustering._case_concept_name_
WHERE level_1_cluster_id = '04'