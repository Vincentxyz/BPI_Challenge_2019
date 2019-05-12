-- Rework Case Level
 Select sum(is_rework) AS count_rework,_case_concept_name_
 INTO DIM.case_rework_count FROM DIM.event_rework
 group by _case_concept_name_
