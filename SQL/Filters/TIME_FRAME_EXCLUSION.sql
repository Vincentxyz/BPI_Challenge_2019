DELETE FROM stg.excluded_cases WHERE exclusion_reason <> 'Incomplete case (no payment)';
Go

-- Add timeframe exlusions
INSERT INTO stg.excluded_cases
SELECT DISTINCT
_case_concept_name_,
'Case not in extraction timeframe'
FROM stg.event_table
WHERE YEAR(_event_time_timestamp_) < 2018
OR _event_time_timestamp_ > '2019-01-28';
Go
