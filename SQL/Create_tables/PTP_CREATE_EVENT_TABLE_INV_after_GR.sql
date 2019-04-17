CREATE VIEW PTP.event_table_INV_after_GR
AS SELECT *
FROM PTP.event_table
WHERE event_table._case_concept_name_ IN 
(SELECT _case_concept_name_ FROM PTP.case_table_INV_after_GR)