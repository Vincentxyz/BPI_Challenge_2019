select _eventID__,_event_concept_name_,_case_concept_name_ ,_event_User_
,DENSE_RANK() over(partition by _case_concept_name_ order by _event_USer_) as resource_count_case 
into DIM.event_handover_of_work
from stg.event_table
where _event_User_ like 'user%'
group by _case_concept_name_,_event_User_,_eventID__,_event_concept_name_