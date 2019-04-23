CREATE TABLE PTP.cluster_id (
"cluster_id" NVARCHAR(100) PRIMARY KEY,
"cluster_name" NVARCHAR(100),
"parent_cluster_id" NVARCHAR(100)
);
Go 

CREATE TABLE PTP.case_clustering (
"_case_concept_name_" NVARCHAR(100) PRIMARY KEY,
"cluster_id" NVARCHAR(100) references PTP.cluster_id(cluster_id)
);
Go 

ALTER TABLE PTP.case_clustering
  ADD level_1_cluster_id NVARCHAR(100);
  Go

ALTER TABLE PTP.case_clustering
  ADD level_2_cluster_id NVARCHAR(100);
  Go

INSERT INTO PTP.case_clustering (
_case_concept_name_
) SELECT
_case_concept_name_
FROM PTP.case_table;
Go