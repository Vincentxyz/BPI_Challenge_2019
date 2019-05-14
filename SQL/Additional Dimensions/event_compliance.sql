
DROP TABLE IF EXISTS #sum_values;
Go

DROP TABLE IF EXISTS stg.event_compliance;
Go

SELECT 
      A.[_case_concept_name_],
	  A._case_item_category_,
	  A._event_concept_name_,
	  A._event_ID__,

	  (SUM(case when B._event_concept_name_ in ('Record Goods Receipt') THEN 1 else 0 END )-SUM(case when B._event_concept_name_ in ('Cancel Goods Receipt') THEN 1 else 0 END )) AS Sum_GR,
	  (SUM(case when B._event_concept_name_ in ('Record Invoice Receipt') THEN 1 else 0 END )-SUM(case when B._event_concept_name_ in ('Cancel Invoice Receipt') THEN 1 else 0 END )) AS Sum_IR,
	  ((SUM(case when B._event_concept_name_ in ('Record Goods Receipt') THEN 1 else 0 END )-SUM(case when B._event_concept_name_ in ('Cancel Goods Receipt') THEN 1 else 0 END ))-(SUM(case when B._event_concept_name_ in ('Record Invoice Receipt') THEN 1 else 0 END )-SUM(case when B._event_concept_name_ in ('Cancel Invoice Receipt') THEN 1 else 0 END ))) AS Deviation,
	  SUM(case when B._event_concept_name_ in ('Clear Invoice') THEN 1 else 0 END ) AS Sum_Payments,
	  (SUM(case when B._event_concept_name_ in ('Create Purchase Order Item') THEN CAST(B.[_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as CreateOrder_NetVal,
	  (SUM(case when B._event_concept_name_ in ('Record Goods Receipt') THEN CAST(B.[_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as GR_NetVal,
	  (SUM(case when B._event_concept_name_ in ('Record Invoice Receipt') THEN CAST(B.[_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as IR_NetVal,
	  (SUM(case when B._event_concept_name_ in ('Cancel Goods Receipt') THEN CAST(B.[_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as CancelGR_NetVal,
	  (SUM(case when B._event_concept_name_ in ('Cancel Invoice Receipt') THEN CAST(B.[_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as CancelIR_NetVal	  
	  INTO #sum_values
	  from PROM.Event_Log_All A
	  JOIN PROM.Event_Log_All B
	  ON A._case_concept_name_ = B._case_concept_name_
	  AND B._event_time_timestamp_ <= A._event_time_timestamp_
	  group by A._case_concept_name_,A._case_item_category_, B._case_concept_name_, A._event_concept_name_, A._event_ID__
	  

SELECT DISTINCT
T1.*,
	
	  CASE
	  -- Two way Matching
	  WHEN T1.Sum_GR = 0 
			AND T1._case_item_category_<> '2-way match' THEN 0
	  WHEN T1.Sum_Payments = 0
			AND T1._case_item_category_<> 'Consignment' THEN 0
	  WHEN T1.Sum_IR=0 and T1._case_item_category_<> 'Consignment' THEN 0
	  WHEN T1._case_item_category_='2-way match' and 
	  T1.CreateOrder_NetVal=(T1.IR_NetVal-T1.CancelIR_NetVal)/T1.Sum_IR THEN 1
	  WHEN  T1._case_item_category_='3-way match, invoice after GR' and
  T1.CreateOrder_NetVal=(T1.IR_NetVal-T1.CancelIR_NetVal)/T1.Sum_IR
    and (T1.IR_NetVal-T1.CancelIR_NetVal)=(T1.GR_NetVal-T1.CancelGR_NetVal)
  and T1.Deviation=0
  and T1.Sum_GR!=0 THEN 1
	WHEN T1._case_item_category_='3-way match, invoice before GR' and
  T1.CreateOrder_NetVal=(T1.IR_NetVal-T1.CancelIR_NetVal)/T1.Sum_IR
  and (T1.IR_NetVal-T1.CancelIR_NetVal)=(T1.GR_NetVal-T1.CancelGR_NetVal)
  and T1.Deviation=0
  and T1.Sum_GR!=0 THEN 1
	WHEN T1._case_item_category_='Consignment' and
	T1.CreateOrder_NetVal = (T1.GR_NetVal-T1.CancelGR_NetVal)/T1.Sum_GR
	THEN 1
	ELSE 0
  	  END AS is_compliant

INTO stg.event_compliance
FROM #sum_values T1

CREATE INDEX ix_event_compliance ON stg.event_compliance(_case_concept_name_);
Go

CREATE INDEX ix_event_compliance_event_id ON stg.event_compliance(_event_ID__);
Go