-- Table for all complete cases with iteration number and sequence number

Select  
_eventID__,_case_concept_name_,_event_concept_name_,_event_time_timestamp_,
Row_Number() Over (Partition By _case_concept_name_, _event_concept_name_ Order By _eventID__ Asc) As iteration_no,
Row_Number() Over (Partition By _case_concept_name_ Order By _eventID__ Asc) As sequence_no
INTO stg.event_sequence
From stg.event_table_filtered where _case_concept_name_ in (select _case_concept_name_ from stg.case_compliance where is_complete=1);

-- Separated the cases which are complete has Cancel IR / Cancel GR
SELECT distinct _case_concept_name_
INTO stg.cases_with_cancel_IR_GRevents
FROM stg.event_table_filtered
where
_case_concept_name_ in (select _case_concept_name_ from stg.case_compliance where is_complete=1)
and _event_concept_name_ in ('Cancel Goods Receipt','Cancel Invoice Receipt');

--190283 cases complete
SELECT distinct _case_concept_name_ from stg.event_sequence;

CREATE SCHEMA CELONIS

-- Throughput Times from Good Receipts To Invoice Receipts 176108 rows

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

-- Average throughput times from Goods receipt to Invoice receipt
select _case_concept_name_, 
avg(ThroughputTime_GRToIR_Days) AS Avg_GRToIR_days,
avg(ThroughputTime_GRToIR_hours) AS Avg_GRToIR_hours
INTO CELONIS.AVG_Times_GRToIR
from CELONIS.ThroughputTimes_GRToIR
group by _case_concept_name_
  

  -- Throughput Times from Invoice To Payment 174231 rows
   
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


-- Average throughput times from Invoice receipt to Payments
select _case_concept_name_, 
avg(ThroughputTime_IRToPayment_Days) AS Avg_IRToPayment_Days,
avg(ThroughputTime_IRToPayment_hours) AS Avg_IRToPayment_hours
INTO CELONIS.AVG_Times_IRToPayment
from CELONIS.ThroughputTimes_IRToPayment
group by _case_concept_name_
  
-- Average throughput_times from GR to IR and IR to Payments
select T1._case_concept_name_,T1.Avg_GRToIR_days,T1.Avg_GRToIR_hours,
T2.Avg_IRToPayment_Days,T2.Avg_IRToPayment_hours
INTO CELONIS.finalthroughputtimes
from CELONIS.AVG_Times_IRToPayment T2,CELONIS.AVG_Times_GRToIR T1
where T1._case_concept_name_=T2._case_concept_name_



select _case_concept_name_
into dbo.temp1
 from CELONIS.ThroughputTimes_IRToPayment

where _case_concept_name_ NOT IN (Select distinct _case_concept_name_ from CELONIS.ThroughputTimes_GRToIR )


CREATE VIEW CELONIS.case_table_throughputTimes
AS 
SELECT *
from stg.case_table_filtered
where _case_concept_name_
in (select _case_concept_name_ from CELONIS.finalthroughputtimes)

CREATE VIEW CELONIS.event_table_throughputTimes
AS 
SELECT *
from stg.event_table_filtered
where _case_concept_name_
in (select _case_concept_name_ from CELONIS.finalthroughputtimes)