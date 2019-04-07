CREATE VIEW PTP.event_table AS
SELECT *
FROM stg.event_table
WHERE _case_concept_name_ NOT IN (SELECT _case_concept_name_ FROM stg.filtered_cases);
Go