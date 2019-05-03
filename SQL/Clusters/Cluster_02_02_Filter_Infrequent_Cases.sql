SELECT Case_Event._event_concept_name_, COUNT(*) As Event_Count
INTO #Event_Count
FROM (
SELECT DISTINCT _case_concept_name_,_event_concept_name_
FROM PROM.CLUSTER_02_02_01_compliant_INV_before_GR_without_SRM_Standard) AS Case_Event
GROUP BY Case_Event._event_concept_name_
Go

DECLARE @case_count INT  = 164031;
Go

SELECT DISTINCT _case_concept_name_ 
INTO stg.CLUSTER_02_02_01_compliant_INV_before_GR_without_SRM_Standard_Filter_Cases
FROM PROM.CLUSTER_02_02_01_compliant_INV_before_GR_without_SRM_Standard
JOIN #Event_Count
ON CLUSTER_02_02_01_compliant_INV_before_GR_without_SRM_Standard._event_concept_name_ = #Event_Count._event_concept_name_
WHERE Event_Count < (164031 * 0.1)
