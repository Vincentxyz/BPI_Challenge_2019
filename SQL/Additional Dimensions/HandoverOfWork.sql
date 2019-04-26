

-- Find the count of distinct users against each case concept name to determine the handover of work.

-- How many different users are associated with each case 

insert into DIM.HANDOVER_OF_WORK
select A._case_concept_name_ , count(distinct B._event_User_) as number_of_handovers from stg.case_table A join stg.event_table B 
on A._case_concept_name_ = B._case_concept_name_
group by A._case_concept_name_