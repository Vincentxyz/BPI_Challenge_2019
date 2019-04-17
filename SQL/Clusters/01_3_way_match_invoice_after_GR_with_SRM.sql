INSERT INTO PTP.cluster_id 
VALUES (
1,
'3-way match, invoice after GR (with SRM)'
);
Go


UPDATE PTP.case_clustering SET cluster_id = 1
FROM PTP.case_clustering 
JOIN PTP.case_table ON
case_clustering._case_concept_name_ = case_table._case_concept_name_
JOIN PTP.event_table ON
event_table._case_concept_name_ = case_table._case_concept_name_
WHERE case_table._case_Item_Category_ = '3-way match, invoice after GR'
AND event_table._event_concept_name_ like '%SRM:%';
Go