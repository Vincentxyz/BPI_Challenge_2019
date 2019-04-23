
UPDATE PTP.case_clustering SET level_1_cluster_id = '01'
FROM PTP.case_clustering 
JOIN PTP.case_table ON
case_clustering._case_concept_name_ = case_table._case_concept_name_
JOIN PTP.event_table ON
event_table._case_concept_name_ = case_table._case_concept_name_
WHERE case_table._case_Item_Category_ = '3-way match, invoice after GR';
Go

UPDATE PTP.case_clustering SET level_1_cluster_id = '02'
FROM PTP.case_clustering 
JOIN PTP.case_table ON
case_clustering._case_concept_name_ = case_table._case_concept_name_
JOIN PTP.event_table ON
event_table._case_concept_name_ = case_table._case_concept_name_
WHERE case_table._case_Item_Category_ = '3-way match, invoice before GR';
Go

UPDATE PTP.case_clustering SET level_1_cluster_id = '03'
FROM PTP.case_clustering 
JOIN PTP.case_table ON
case_clustering._case_concept_name_ = case_table._case_concept_name_
JOIN PTP.event_table ON
event_table._case_concept_name_ = case_table._case_concept_name_
WHERE case_table._case_Item_Category_ = '2-way match';
Go

UPDATE PTP.case_clustering SET level_1_cluster_id = '04'
FROM PTP.case_clustering 
JOIN PTP.case_table ON
case_clustering._case_concept_name_ = case_table._case_concept_name_
JOIN PTP.event_table ON
event_table._case_concept_name_ = case_table._case_concept_name_
WHERE case_table._case_Item_Category_ = 'Consignment';
Go