CREATE VIEW PROM.CLUSTERS_04_Consignment
AS 
SELECT stg.case_table_filtered.*, case_clustering.level_2_cluster_id
FROM stg.case_table_filtered
JOIN stg.case_clustering
ON case_table_filtered._case_concept_name_ = case_clustering._case_concept_name_
WHERE level_1_cluster_id = '04'