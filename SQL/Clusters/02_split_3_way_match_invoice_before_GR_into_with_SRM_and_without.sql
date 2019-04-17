INSERT INTO PTP.cluster_id 
VALUES (
'02-01',
'3-way match, invoice before GR (with SRM)'
,'02'
);
Go

INSERT INTO PTP.cluster_id 
VALUES (
'02-02',
'3-way match, invoice before GR (without SRM)'
,'02'
);
Go


UPDATE PTP.case_clustering SET cluster_id = '02-01'
FROM PTP.case_clustering 
JOIN PTP.case_table ON
case_clustering._case_concept_name_ = case_table._case_concept_name_
JOIN PTP.event_table ON
event_table._case_concept_name_ = case_table._case_concept_name_
WHERE case_table._case_Item_Category_ = '3-way match, invoice before GR'
AND event_table._event_concept_name_ like '%SRM:%';
Go

UPDATE PTP.case_clustering SET cluster_id = '02-02'
FROM PTP.case_clustering 
JOIN PTP.case_table ON
case_clustering._case_concept_name_ = case_table._case_concept_name_
JOIN PTP.event_table ON
event_table._case_concept_name_ = case_table._case_concept_name_
WHERE case_table._case_Item_Category_ = '3-way match, invoice before GR'
AND event_table._event_concept_name_ NOT like '%SRM:%';
Go