CREATE TABLE stg.cluster_id (
"cluster_id" INT PRIMARY KEY,
"cluster_name" NVARCHAR(100)
);
Go 

CREATE INDEX ix_cluster_id ON stg.cluster_id (cluster_id);
Go

CREATE TABLE stg.case_clustering (
"_case_concept_name_" NVARCHAR(100) PRIMARY KEY,
"level_1_cluster_id" NVARCHAR(100),
"level_2_cluster_id" NVARCHAR(100),
"level_3_cluster_id" NVARCHAR(100),
"final_cluster" NVARCHAR(100)
);
Go 

INSERT INTO stg.case_clustering (
_case_concept_name_
) SELECT
_case_concept_name_
FROM stg.case_table_filtered;
Go

CREATE INDEX ix_case_clustering
ON stg.case_clustering
(
	_case_concept_name_
)
GO
