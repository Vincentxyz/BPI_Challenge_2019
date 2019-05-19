update T1
set T1.is_complete  = T2.is_complete
from stg.event_compliance T1
join stg.case_compliance T2
on T1._case_concept_name_ = T2._case_concept_name_
where T2.is_complete = 1