SELECT  
      [_case_concept_name_],
	  _case_item_category_,
	  (SUM(case when _event_concept_name_ in ('Record Goods Receipt') THEN 1 else 0 END )-SUM(case when _event_concept_name_ in ('Cancel Goods Receipt') THEN 1 else 0 END )) AS Sum_GR,
	  (SUM(case when _event_concept_name_ in ('Record Invoice Receipt') THEN 1 else 0 END )-SUM(case when _event_concept_name_ in ('Cancel Invoice Receipt') THEN 1 else 0 END )) AS Sum_IR,
	  ((SUM(case when _event_concept_name_ in ('Record Goods Receipt') THEN 1 else 0 END )-SUM(case when _event_concept_name_ in ('Cancel Goods Receipt') THEN 1 else 0 END ))-(SUM(case when _event_concept_name_ in ('Record Invoice Receipt') THEN 1 else 0 END )-SUM(case when _event_concept_name_ in ('Cancel Invoice Receipt') THEN 1 else 0 END ))) AS Deviation,
	  SUM(case when _event_concept_name_ in ('Clear Invoice') THEN 1 else 0 END ) AS Sum_Payments,
	  (SUM(case when _event_concept_name_ in ('Create Purchase Order Item') THEN CAST([_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as CreateOrder_NetVal,
	  (SUM(case when _event_concept_name_ in ('Record Goods Receipt') THEN CAST([_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as GR_NetVal,
	  (SUM(case when _event_concept_name_ in ('Record Invoice Receipt') THEN CAST([_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as IR_NetVal,
	  (SUM(case when _event_concept_name_ in ('Cancel Goods Receipt') THEN CAST([_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as CancelGR_NetVal,
	  (SUM(case when _event_concept_name_ in ('Cancel Invoice Receipt') THEN CAST([_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as CancelIR_NetVal	  
	  INTO #sum_values
	  from PROM.Event_Log_All
	  group by _case_concept_name_,_case_item_category_
	  

SELECT DISTINCT
T1.*,
	
	  CASE
	  -- Two way Matching
	  WHEN T1.Sum_GR = 0 AND T1._case_item_category_<> '2-way match' THEN 0
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

INTO DIM.case_compliance
FROM #sum_values T1
