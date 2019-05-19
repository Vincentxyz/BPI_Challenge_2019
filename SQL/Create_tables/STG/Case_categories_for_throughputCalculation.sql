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


-- Categorised the cases based on time difference
SELECT T1._case_concept_name_,T1.iteration_no,CC._case_item_category_,
CASE WHEN DATEDIFF(hour, T1._event_time_timestamp_,T2._event_time_timestamp_)<0 AND CC._case_item_category_='3-way match, invoice after GR' 
then '03_01_01'  -- 01_01
WHEN DATEDIFF(hour, T1._event_time_timestamp_,T2._event_time_timestamp_)>=0 AND CC._case_item_category_='3-way match, invoice after GR' 
then '03_01_02'  -- 01_02
WHEN DATEDIFF(hour, T1._event_time_timestamp_,T2._event_time_timestamp_)<0 AND CC._case_item_category_='3-way match, invoice before GR' 
then '03_02_01' -- 02_01
WHEN DATEDIFF(hour, T1._event_time_timestamp_,T2._event_time_timestamp_)>=0 AND CC._case_item_category_='3-way match, invoice before GR' 
then '03_02_02'  -- 02_02
WHEN CC._case_item_category_='2-way match' THEN '02' -- 03
ELSE '01'
END AS category_type
INTO stg.casecategories_forTime
from stg.event_sequence T1,stg.event_sequence T2, stg.case_compliance CC
where T1._case_concept_name_=CC._case_concept_name_ and 
T2._case_concept_name_=CC._case_concept_name_
and T1._case_concept_name_=T2._case_concept_name_
and T1._event_concept_name_='Record Goods Receipt'
and T2._event_concept_name_ in ('Record Invoice Receipt')
and T1.iteration_no=T2.iteration_no
and T1._case_concept_name_ NOT IN (SELECT distinct _case_concept_name_ from stg.cases_with_cancel_IR_GRevents)



UPDATE stg.casecategories_forTime
SET category_type='01_01'
where category_type='03_01_01'
GO


UPDATE stg.casecategories_forTime
SET category_type='01_02'
where category_type='03_01_02'
GO

UPDATE stg.casecategories_forTime
SET category_type='02_01'
where category_type='03_02_01'
GO

UPDATE stg.casecategories_forTime
SET category_type='02_02'
where category_type='03_02_02'
GO

