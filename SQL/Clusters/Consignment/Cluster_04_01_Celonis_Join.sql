
  UPDATE [PTP].[case_clustering]
  SET [level_2_cluster_id] = '04-01'
  FROM [PTP].[case_clustering]
  JOIN [dbo].[Cluster_04_01_Celonis_Export]
  ON case_clustering._case_concept_name_ = Cluster_04_01_Celonis_Export.["Case-concept name"]
  AND case_clustering.[level_1_cluster_id] = '04'