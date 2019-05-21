

SELECT T1._case_concept_name_,T1.iteration_no,CC._case_item_category_,
DATEDIFF(day, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_IRToPayment_Days,
DATEDIFF(hour, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_IRToPayment_hours
INTO stg._03_IRToPayment_perCase
from stg.event_sequence T1,stg.event_sequence T2, stg.case_compliance CC
where T1._case_concept_name_=CC._case_concept_name_ and 
T2._case_concept_name_=CC._case_concept_name_
and T1._case_concept_name_=T2._case_concept_name_
and CC._case_item_category_='2-way match'
and T1._event_concept_name_='Record Invoice Receipt'
and T2._event_concept_name_ in ('Clear Invoice')
and T1.iteration_no=T2.iteration_no


select _case_concept_name_, _case_item_category_,
avg(ThroughputTime_IRToPayment_Days) AS Avg_IRToPayment_Days,
avg(ThroughputTime_IRToPayment_hours) AS Avg_IRToPayment_hours
INTO stg._03_Throughputtimes_Invoicing
from stg._03_IRToPayment_perCase
group by _case_concept_name_, _case_item_category_