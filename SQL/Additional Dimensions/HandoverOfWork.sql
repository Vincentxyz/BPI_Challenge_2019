

-- Find the count of distinct users against each case concept name to determine the handover of work.

-- How many different users are associated with each case 
truncate table [DIM].[case_handover_of_work]
insert into [DIM].[case_handover_of_work]
select A._case_concept_name_ , count(distinct B._event_User_) as number_of_handovers 
from stg.case_table_filtered A join stg.event_table_filtered B 
on A._case_concept_name_ = B._case_concept_name_
where _event_User_ like 'user%'
group by A._case_concept_name_