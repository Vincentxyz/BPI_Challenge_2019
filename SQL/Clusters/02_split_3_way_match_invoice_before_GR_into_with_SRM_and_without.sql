INSERT INTO PTP.cluster_id 
VALUES (
'02-01',
'3-way match, invoice before GR (with SRM)'
);
Go

INSERT INTO PTP.cluster_id 
VALUES (
'02-02',
'3-way match, invoice before GR (without SRM)'
);
Go



UPDATE stg.case_clustering SET level_2_cluster_id = '02-01'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
JOIN stg.event_table_filtered ON
event_table_filtered._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice before GR'
AND event_table_filtered._event_concept_name_ like '%SRM:%';
Go

UPDATE stg.case_clustering SET level_2_cluster_id = '02-02'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice before GR'
AND case_table_filtered._case_concept_name_ NOT IN 
(SELECT DISTINCT _case_concept_name_ FROM stg.event_table_filtered
WHERE event_table_filtered._event_concept_name_  like '%SRM:%');
Go