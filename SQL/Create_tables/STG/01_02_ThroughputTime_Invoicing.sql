-- cases belonging to 01-01 are not considered.

-- Throughput calculation for '3-way match invoice after GR' 

-- Time difference between Goods receipt and Invoice Receipt for each iteration_no
SELECT T1._case_concept_name_,T1.iteration_no,TT._case_item_category_,TT.category_type,
DATEDIFF(day, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_GRToIR_Days,
DATEDIFF(hour, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_GRToIR_hours
INTO stg._01_02_Time_GRToIR_periteration
from stg.event_sequence T1,stg.event_sequence T2, stg.casecategories_forTime TT
where 
TT.category_type='01_02' and 
T1._case_concept_name_=TT._case_concept_name_ and 
T2._case_concept_name_=TT._case_concept_name_ and 
T1._case_concept_name_=T2._case_concept_name_
and T1._event_concept_name_='Record Goods Receipt'
and T2._event_concept_name_ in ('Record Invoice Receipt')
and T1.iteration_no=T2.iteration_no
and T1.iteration_no=TT.iteration_no
and T2.iteration_no=TT.iteration_no

-- Time difference between Invoice Receipt  and clear payment for each iteration_no
SELECT T1._case_concept_name_,T1.iteration_no,TT._case_item_category_,TT.category_type,
DATEDIFF(day, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_IRToPayment_Days,
DATEDIFF(hour, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_IRToPayment_hours
INTO stg._01_02_Time_IRToPayment_periteration
from stg.event_sequence T1,stg.event_sequence T2, stg.casecategories_forTime TT
where 
TT.category_type='01_02' and 
T1._case_concept_name_=TT._case_concept_name_ and 
T2._case_concept_name_=TT._case_concept_name_ and 
T1._case_concept_name_=T2._case_concept_name_
and T1._event_concept_name_='Record Invoice Receipt'
and T2._event_concept_name_ in ('Clear Invoice')
and T1.iteration_no=T2.iteration_no
and T1.iteration_no=TT.iteration_no
and T2.iteration_no=TT.iteration_no


-- Time difference between Goods receipt and Invoice Receipt for each case - average of all iterations
select _case_concept_name_, _case_item_category_,
avg(ThroughputTime_GRToIR_Days) AS Avg_GRToIR_Days,
avg(ThroughputTime_GRToIR_hours) AS Avg_GRToIR_hours
INTO stg.01_02_GRToIR_perCase
from stg._01_02_Time_GRToIR_periteration
group by _case_concept_name_,_case_item_category_

-- Time difference between Invoice Receipt  and clear payment for each case - average of all iterations
select _case_concept_name_, _case_item_category_,
avg(ThroughputTime_IRToPayment_Days) AS Avg_IRToPayment_Days,
avg(ThroughputTime_IRToPayment_hours) AS Avg_IRToPayment_hours
INTO stg._01_02_IRToPayment_perCase
from stg._01_02_Time_IRToPayment_periteration
group by _case_concept_name_,_case_item_category_

-- time difference between Goods receipt to  Invoice Receipt and Invoice Receipt  to clear payment
Select T1._case_concept_name_,T1._case_item_category_,
T1. Avg_GRToIR_Days,T1.Avg_GRToIR_hours,
T2.Avg_IRToPayment_Days,T2. Avg_IRToPayment_hours
INTO stg._01_02_Throughputtimes_Invoicing
from stg._01_02_IRToPayment_perCase T2,
stg._01_02_GRToIR_perCase T1
where T1._case_concept_name_=T2._case_concept_name_