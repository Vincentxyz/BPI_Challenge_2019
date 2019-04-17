INSERT INTO PTP.cluster_id 
VALUES (
'01-01',
'3-way match, invoice after GR (with SRM)'
,'01'
);
Go

INSERT INTO PTP.cluster_id 
VALUES (
'01-02',
'3-way match, invoice after GR (without SRM)'
,'01'
);
Go


UPDATE PTP.case_clustering SET cluster_id = '01-01'
FROM PTP.case_clustering 
JOIN PTP.case_table ON
case_clustering._case_concept_name_ = case_table._case_concept_name_
JOIN PTP.event_table ON
event_table._case_concept_name_ = case_table._case_concept_name_
WHERE case_table._case_Item_Category_ = '3-way match, invoice after GR'
AND event_table._event_concept_name_ like '%SRM:%';
Go

UPDATE PTP.case_clustering SET cluster_id = '01-02'
FROM PTP.case_clustering 
JOIN PTP.case_table ON
case_clustering._case_concept_name_ = case_table._case_concept_name_
JOIN PTP.event_table ON
event_table._case_concept_name_ = case_table._case_concept_name_
WHERE case_table._case_Item_Category_ = '3-way match, invoice after GR'
AND event_table._event_concept_name_ NOT like '%SRM:%';
Go