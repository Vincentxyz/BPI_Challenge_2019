select _case_concept_name_,_eventID__,_event_time_timestamp_,_event_concept_name_,
ROW_NUMBER() over (partition by _case_concept_name_ order by _eventID__) as sequence_number
into stg.input_for_classification
from stg.event_table
group by _case_concept_name_,_eventID__ ,_event_time_timestamp_,_event_concept_name_