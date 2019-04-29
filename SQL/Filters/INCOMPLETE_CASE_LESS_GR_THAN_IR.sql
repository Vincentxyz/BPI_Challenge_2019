DELETE FROM stg.excluded_cases WHERE exclusion_reason <> 'Incomplete case (GR < IR and Consignment)';
Go

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

-- Add cases with less GR than IR (Consignment)
INSERT INTO stg.excluded_cases
SELECT DISTINCT
_case_concept_name_,
'Incomplete case (GR < IR and Consignment)'
FROM #sum_values
WHERE Sum_GR < Sum_IR
AND _case_item_category_ = 'Consignment'
Go

-- Add cases with less GR than IR (Multi-invoice)
INSERT INTO stg.excluded_cases
SELECT DISTINCT
_case_concept_name_,
'Incomplete case (GR < IR and Multi-Invoice)'
FROM #sum_values
WHERE Sum_GR < Sum_IR
AND Sum_GR > 1
AND _case_item_category_ <> 'Consignment'
Go