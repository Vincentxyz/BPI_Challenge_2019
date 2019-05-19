/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [final_cluster]
      ,[cluster_name]
	  , COUNT(_case_concept_name_)
  FROM [PROM].[compliant_case_clustering]
    GROUP BY final_cluster, cluster_name
  ORDER BY final_cluster
