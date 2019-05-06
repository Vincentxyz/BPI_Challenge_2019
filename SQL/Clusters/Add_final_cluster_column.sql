ALTER TABLE stg.case_clustering ADD "final_cluster" NVARCHAR(100);
Go

UPDATE stg.case_clustering SET final_cluster =  CASE 
		WHEN level_3_cluster_id IS NOT NULL THEN level_3_cluster_id
		WHEN level_2_cluster_id IS NOT NULL THEN level_2_cluster_id
		WHEN level_1_cluster_id IS NOT NULL THEN level_1_cluster_id
		ELSE 'NA'
		END;
		Go