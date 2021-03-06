SELECT T1._case_concept_name_,T1.iteration_no,T1._case_Item_Category_,
  DATEDIFF(hour, T1._event_time_timestamp_,T2._event_time_timestamp_)/24.0 AS ThroughputTime_GRToIR
  INTO stg.throughput_time
  from stg.event_sequence T1,stg.event_sequence T2
  where T1._case_concept_name_=T2._case_concept_name_
  and T1._event_concept_name_='Record Goods Receipt'
  and T2._event_concept_name_ in ('Record Invoice Receipt')
  --and T1.case_Item_Category='3-way match, invoice after GR'
  and T1.iteration_no=T2.iteration_no
  and T1._case_concept_name_ NOT IN (SELECT distinct _case_concept_name_ from stg.cancel_receipt_cases)
 -- order by ThroughputTime_GRToIR 