DROP VIEW IF EXISTS PROM.case_clustering_with_compliance;
Go

CREATE VIEW PROM.case_clustering_with_compliance AS
SELECT case_clustering.*, case_compliance._case_item_category_, id_1.cluster_name AS 'level_1_cluster_name', id_2.cluster_name AS 'level_2_cluster_name', id_3.cluster_name AS 'level_3_cluster_name', case_compliance.is_compliant FROM stg.case_clustering 
JOIN stg.case_compliance
ON case_clustering._case_concept_name_ = case_compliance._case_concept_name_
LEFT JOIN stg.cluster_id id_1
ON case_clustering.level_1_cluster_id = id_1.cluster_id
LEFT JOIN stg.cluster_id id_2
ON case_clustering.level_2_cluster_id = id_2.cluster_id
LEFT JOIN stg.cluster_id id_3
ON case_clustering.level_3_cluster_id = id_3.cluster_id;
Go