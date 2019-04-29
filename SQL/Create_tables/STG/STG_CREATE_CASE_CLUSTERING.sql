CREATE TABLE stg.cluster_id (
"cluster_id" INT PRIMARY KEY,
"cluster_name" NVARCHAR(100)
);
Go 

CREATE INDEX ix_cluster_id ON stg.cluster_id (cluster_id);
Go

CREATE TABLE stg.case_clustering (
"_case_concept_name_" NVARCHAR(100) PRIMARY KEY,
"cluster_id" INT references PTP.cluster_id(cluster_id)
);
Go 

INSERT INTO stg.case_clustering (
_case_concept_name_
) SELECT
_case_concept_name_
FROM PTP.case_table;
Go

CREATE INDEX ix_case_clustering
ON stg.case_clustering
(
	_case_concept_name_
)
GO
