CREATE VIEW PTP.event_table_two_way_matching 
AS SELECT *
FROM PTP.event_table
WHERE event_table._case_concept_name_ IN 
(SELECT _case_concept_name_ FROM PTP.case_table_two_way_matching)