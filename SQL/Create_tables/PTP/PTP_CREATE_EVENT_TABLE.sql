SELECT event_table.*,
Event_Sorting.Sorting
INTO STG.event_table_filtered
FROM stg.event_table
JOIN stg.Event_Sorting
ON event_table._event_concept_name_ = Event_Sorting._event_concept_name_
WHERE _case_concept_name_ NOT IN (SELECT _case_concept_name_ FROM stg.excluded_cases);
Go

CREATE INDEX ix_event_table_filtered
ON stg.event_table_filtered (_case_concept_name_, _event_concept_name_, _event_time_timestamp_)

CREATE INDEX ix_event_table_filtered_event_id
ON stg.event_table_filtered (_eventID__)