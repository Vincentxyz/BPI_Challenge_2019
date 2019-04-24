-- Find first Purchase order item creation

SELECT _case_concept_name_,
		MIN(_event_time_timestamp_) AS First_POI_Creation_Time
INTO #PO_Creation
FROM PROM.Event_Log_All
GROUP BY _case_concept_name_, _event_concept_name_
HAVING _event_concept_name_ = 'Create Purchase Order Item'

-- Find first invoice creation

SELECT _case_concept_name_,
		MIN(_event_time_timestamp_) AS First_Invoice_Record_Time
INTO #Invoice_Creation
FROM PROM.Event_Log_All
GROUP BY _case_concept_name_, _event_concept_name_
HAVING _event_concept_name_ = 'Record Invoice Receipt'

-- Find first GR creation

SELECT _case_concept_name_,
		MIN(_event_time_timestamp_) AS First_GR_Record_Time
INTO #GR_Creation
FROM PROM.Event_Log_All
GROUP BY _case_concept_name_, _event_concept_name_
HAVING _event_concept_name_ = 'Record Goods Receipt'

SELECT 
	Event_log_All._case_concept_name_
	  , _event_concept_name_
      , [_event_time_timestamp_]
	 , CASE 
		WHEN ISNULL(First_POI_Creation_Time,CONVERT(DATETIME,'1900-01-01 00:00:00')) >= ISNULL(First_Invoice_Record_Time, CONVERT(DATETIME,'2100-01-01 00:00:00')) THEN 1
		WHEN ISNULL(First_POI_Creation_Time,CONVERT(DATETIME,'1900-01-01 00:00:00')) >= ISNULL(First_GR_Record_Time, CONVERT(DATETIME,'2100-01-01 00:00:00')) THEN 1
		ELSE 0 
		END AS event_retrospective_POI
	 , #PO_Creation.First_POI_Creation_Time
	 , #Invoice_Creation.First_Invoice_Record_Time
	 , #GR_Creation.First_GR_Record_Time
INTO DIM.Retrospective_PO_Items
FROM PROM.Event_Log_All
LEFT JOIN #PO_Creation
ON Event_Log_All._case_concept_name_ = #PO_Creation._case_concept_name_
AND Event_Log_All._event_time_timestamp_ >= #PO_Creation.First_POI_Creation_Time
LEFT JOIN #Invoice_Creation
ON Event_Log_All._case_concept_name_ = #Invoice_Creation._case_concept_name_
AND Event_Log_All._event_time_timestamp_ >= #Invoice_Creation.First_Invoice_Record_Time
LEFT JOIN #GR_Creation
ON Event_Log_All._case_concept_name_ = #GR_Creation._case_concept_name_
AND Event_Log_All._event_time_timestamp_ >= #GR_Creation.First_GR_Record_Time
