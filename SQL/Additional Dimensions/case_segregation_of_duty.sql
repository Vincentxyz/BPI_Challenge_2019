/* 
- Find cases which a person did both tasks 'Create Purchase Order Item' and 'Record Goods Receipt' 
- There are NO case which a person did both tasks 'Create Purchase Order Item' and 'Record Invoice Receipt' 
- Output : Save only [_case_concept_name_] which a person did both two tasks
"*/
DROP TABLE IF EXISTS [DIM].[case_segregation_of_duty];
Go

SELECT distinct A.[_case_concept_name_],
	 CASE WHEN A._event_User_ like 'user%' AND ISNULL(B._case_concept_name_,'') <> '' THEN 1 ELSE 0 END AS create_poi_and_gr,
	 CASE WHEN A._event_User_ like 'user%' AND ISNULL(C._case_concept_name_,'') <> '' THEN 1 ELSE 0 END AS create_poi_and_ir
INTO [DIM].[case_segregation_of_duty]

FROM PROM.Event_log_All A 
LEFT JOIN PROM.Event_log_All B
ON B.[_case_concept_name_]=A.[_case_concept_name_]
AND B._event_concept_name_='Record Goods Receipt'
AND A._event_User_ = B._event_User_
AND A._event_ID__ <> B._event_ID__
LEFT JOIN PROM.Event_log_All C
ON C.[_case_concept_name_]=A.[_case_concept_name_]
AND C._event_concept_name_='Record Invoice Receipt'
AND A._event_User_ = C._event_User_
AND A._event_ID__ <> C._event_ID__
WHERE A._event_concept_name_='Create Purchase Order Item'