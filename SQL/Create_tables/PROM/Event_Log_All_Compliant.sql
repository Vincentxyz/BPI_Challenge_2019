CREATE VIEW PROM.Event_Log_Compliant AS
SELECT Event_log_All.* FROM PROM.Event_log_All
JOIN stg.case_compliance
on Event_log_All._case_concept_name_ = case_compliance._case_concept_name_
AND case_compliance.is_compliant = 1
