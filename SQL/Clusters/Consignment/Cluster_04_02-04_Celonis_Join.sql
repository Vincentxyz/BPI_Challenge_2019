
  UPDATE [PTP].[case_clustering]
  SET [level_2_cluster_id] = '04-02'
  FROM [PTP].[case_clustering]
  JOIN [dbo].[Cluster_04_02_Celonis_Export]
  ON case_clustering._case_concept_name_ = Cluster_04_02_Celonis_Export.[Case-concept name]
  AND case_clustering.[level_1_cluster_id] = '04'

    UPDATE [PTP].[case_clustering]
  SET [level_2_cluster_id] = '04-03'
  FROM [PTP].[case_clustering]
  JOIN [dbo].[Cluster_04_03_Celonis_Export]
  ON case_clustering._case_concept_name_ = Cluster_04_03_Celonis_Export.["Case-concept name"]
  AND case_clustering.[level_1_cluster_id] = '04'

  
    UPDATE [PTP].[case_clustering]
  SET [level_2_cluster_id] = '04-04'
  FROM [PTP].[case_clustering]
  JOIN [dbo].[Cluster_04_04_Celonis_Export]
  ON case_clustering._case_concept_name_ = Cluster_04_04_Celonis_Export.["Case-concept name"]
  AND case_clustering.[level_1_cluster_id] = '04'