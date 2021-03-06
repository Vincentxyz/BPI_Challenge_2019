/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [final_cluster], cluster_name, COUNT(*) As [count of cases]
  FROM [stg].[case_clustering]
  JOIN stg.cluster_id
  ON case_clustering.final_cluster = cluster_id.cluster_id
  JOIN stg.case_compliance
  ON case_clustering._case_concept_name_ = case_compliance._case_concept_name_
  AND case_compliance.is_compliant = 1
  GROUP BY [final_cluster], cluster_name