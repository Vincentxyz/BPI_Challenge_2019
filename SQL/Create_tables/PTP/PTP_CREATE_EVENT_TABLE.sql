CREATE VIEW PTP.event_table AS
SELECT event_table.*,
Event_Sorting.Sorting
FROM stg.event_table
JOIN dbo.Event_Sorting
ON event_table._event_concept_name_ = Event_Sorting._event_concept_name
WHERE _case_concept_name_ NOT IN (SELECT _case_concept_name_ FROM stg.filtered_cases);
Go