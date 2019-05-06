DROP TABLE IF EXISTS #case_event_count;
Go

DROP TABLE IF EXISTS stg.count_cases_per_event;
Go

SELECT _case_concept_name_, _event_concept_name_, COUNT(*) AS count_case_event
INTO #case_event_count
FROM PROM.Event_log_Compliant 
GROUP BY _case_concept_name_, _event_concept_name_;
Go

SELECT _event_concept_name_, COUNT(*) as case_count
INTO stg.count_compliant_cases_per_event
FROM #case_event_count
WHERE count_case_event > 0
GROUP BY _event_concept_name_;
Go
