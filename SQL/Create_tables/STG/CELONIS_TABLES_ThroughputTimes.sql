-- Table for all cases with iteration number and sequence number

Select  
_eventID__,_case_concept_name_,_event_concept_name_,_event_time_timestamp_,
Row_Number() Over (Partition By _case_concept_name_, _event_concept_name_ Order By _eventID__ Asc) As iteration_no,
Row_Number() Over (Partition By _case_concept_name_ Order By _eventID__ Asc) As sequence_no
INTO stg.Newevent_sequence
From stg.event_table_filtered;

-- Separated the cases which has Cancel IR / Cancel GR
SELECT distinct _case_concept_name_
INTO stg.cases_with_cancel_IR_GRevents
FROM stg.event_table_filtered
where
_event_concept_name_ in ('Cancel Goods Receipt','Cancel Invoice Receipt');

CREATE SCHEMA CELONIS

-- Throughput Times from Good Receipts To Invoice Receipts 

SELECT T1._case_concept_name_,T1.iteration_no,
DATEDIFF(day, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_GRToIR_Days,
DATEDIFF(hour, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_GRToIR_hours
INTO CELONIS.ThroughputTimes_GRToIR
from stg.event_sequence T1,stg.event_sequence T2
where T1._case_concept_name_=T2._case_concept_name_
and T1._event_concept_name_='Record Goods Receipt'
and T2._event_concept_name_ in ('Record Invoice Receipt')
and T1.iteration_no=T2.iteration_no
and T1._case_concept_name_ NOT IN (SELECT distinct _case_concept_name_ from stg.cases_with_cancel_IR_GRevents)
  

  -- Throughput Times from Invoice To Payment
   
SELECT T1._case_concept_name_,T1.iteration_no,
DATEDIFF(day, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_IRToPayment_Days,
DATEDIFF(hour, T1._event_time_timestamp_,T2._event_time_timestamp_) AS ThroughputTime_IRToPayment_hours
INTO CELONIS.ThroughputTimes_IRToPayment
from stg.event_sequence T1,stg.event_sequence T2
where T1._case_concept_name_=T2._case_concept_name_
and T1._event_concept_name_='Record Invoice Receipt'
and T2._event_concept_name_ in ('Clear Invoice')
and T1.iteration_no=T2.iteration_no
and T1._case_concept_name_ NOT IN (SELECT distinct _case_concept_name_ from stg.cases_with_cancel_IR_GRevents)