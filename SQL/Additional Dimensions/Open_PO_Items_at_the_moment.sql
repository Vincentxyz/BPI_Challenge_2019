-- Find first event of a case

PRINT('#POI_Start will now be created');
Go


IF OBJECT_ID('tempdb..#POI_Start') IS NOT NULL DROP TABLE #POI_Start
GO

SELECT _case_concept_name_,
		MIN(_event_time_timestamp_) AS First_POI_Activity
INTO #POI_Start
FROM PROM.Event_Log_All
GROUP BY _case_concept_name_



PRINT('#POI_End will now be created');
Go

-- Find last event of a case
IF OBJECT_ID('tempdb..#POI_End') IS NOT NULL DROP TABLE #POI_End
GO

SELECT _case_concept_name_,
		MAX(_event_time_timestamp_) AS Last_POI_Activity
INTO #POI_End
FROM PROM.Event_Log_All
GROUP BY _case_concept_name_


PRINT('#POI_Start and #POI_End are now merged');
Go
IF OBJECT_ID('tempdb..#POI_Duration') IS NOT NULL DROP TABLE #POI_Duration
GO

SELECT #POI_Start._case_concept_name_, First_POI_Activity, Last_POI_Activity
INTO #POI_Duration
FROM 
#POI_Start JOIN #POI_End
ON #POI_Start._case_concept_name_ = #POI_End._case_concept_name_

PRINT('#OPEN_POIs is now created');
Go

SELECT [_event_ID__],
Event_log_all.[_case_concept_name_],
[_event_concept_name_],
[_event_time_timestamp_],
COUNT(#POI_Duration._case_concept_name_)
FROM PROM.Event_log_All
JOIN #POI_Duration
ON #POI_Duration._case_concept_name_ = Event_log_All._case_concept_name_
GROUP BY _event_ID__,Event_Log_All._case_concept_name_, _event_concept_name_, _event_time_timestamp_