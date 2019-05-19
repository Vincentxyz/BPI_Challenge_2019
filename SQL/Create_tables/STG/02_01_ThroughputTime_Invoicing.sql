SELECT T1._case_concept_name_,T1.iteration_no,TT._case_item_category_,TT.category_type,
DATEDIFF(day, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_IRToGR_Days,
DATEDIFF(hour, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_IRToGR_hours
INTO stg._02_01_Time_IRToGR_periteration
from stg.event_sequence T1,stg.event_sequence T2, stg.casecategories_forTime TT
where 
TT.category_type='02_01' and 
T1._case_concept_name_=TT._case_concept_name_ and 
T2._case_concept_name_=TT._case_concept_name_ and 
T1._case_concept_name_=T2._case_concept_name_
and T1._event_concept_name_='Record Invoice Receipt'
and T2._event_concept_name_ in ('Record Goods Receipt')
and T1.iteration_no=T2.iteration_no
and T1.iteration_no=TT.iteration_no
and T2.iteration_no=TT.iteration_no

SELECT T1._case_concept_name_,T1.iteration_no,TT._case_item_category_,TT.category_type,
DATEDIFF(day, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_GRToPayment_Days,
DATEDIFF(hour, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_GRToPayment_hours
INTO stg._02_01_Time_GRToPayment_periteration
from stg.event_sequence T1,stg.event_sequence T2, stg.casecategories_forTime TT
where 
TT.category_type='02_01' and 
T1._case_concept_name_=TT._case_concept_name_ and 
T2._case_concept_name_=TT._case_concept_name_ and 
T1._case_concept_name_=T2._case_concept_name_
and T1._event_concept_name_='Record Goods Receipt'
and T2._event_concept_name_ in ('Clear Invoice')
and T1.iteration_no=T2.iteration_no
and T1.iteration_no=TT.iteration_no
and T2.iteration_no=TT.iteration_no




select _case_concept_name_, _case_item_category_,
avg(ThroughputTime_IRToGR_Days) AS Avg_IRToGR_Days,
avg(ThroughputTime_IRToGR_hours) AS Avg_IRToGR_hours
INTO stg._02_01_IRToGR_perCase
from stg._02_01_Time_IRToGR_periteration
group by _case_concept_name_,_case_item_category_

select _case_concept_name_, _case_item_category_,
avg(ThroughputTime_GRToPayment_Days) AS Avg_GRToPayment_Days,
avg(ThroughputTime_GRToPayment_hours) AS Avg_GRToPayment_hours
INTO stg._02_01_GRToPayment_perCase
from stg._02_01_Time_GRToPayment_periteration
group by _case_concept_name_,_case_item_category_

Select T1._case_concept_name_,T1._case_item_category_,
T1. Avg_IRToGR_Days,T1.Avg_IRToGR_hours,
T2.Avg_GRToPayment_Days,T2.Avg_GRToPayment_hours
INTO stg._02_01_Throughputtimes_Invoicing
from stg._02_01_GRToPayment_perCase T2,
stg._02_01_IRToGR_perCase T1
where T1._case_concept_name_=T2._case_concept_name_



