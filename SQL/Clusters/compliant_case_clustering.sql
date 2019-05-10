CREATE VIEW PROM.compliant_case_clustering
AS SELECT case_clustering.[_case_concept_name_]
      ,final_cluster
	  ,cluster_name
	  ,[level_1_cluster_id]
      ,[level_2_cluster_id]
      ,[level_3_cluster_id]
  FROM [stg].[case_clustering]
  JOIN stg.case_compliance ON case_clustering._case_concept_name_ = case_compliance._case_concept_name_
  AND case_compliance.is_compliant = 1
  LEFT JOIN stg.cluster_id
  ON case_clustering.final_cluster = cluster_id.cluster_id