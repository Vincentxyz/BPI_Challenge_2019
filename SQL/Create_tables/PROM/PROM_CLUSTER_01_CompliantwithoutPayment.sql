Select 
[_case_concept_name_],
(SUM(case when _event_concept_name_ in ('Create Purchase Order Item') THEN CAST([_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as CreateOrder_NetVal,
(SUM(case when _event_concept_name_ in ('Record Invoice Receipt') THEN CAST([_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as IR_NetVal,
(SUM(case when _event_concept_name_ in ('Record Goods Receipt') THEN CAST([_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as GR_NetVal,
(SUM(case when _event_concept_name_ in ('Cancel Goods Receipt') THEN CAST([_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as CancelGR_NetVal,
	  (SUM(case when _event_concept_name_ in ('Cancel Invoice Receipt') THEN CAST([_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as CancelIR_NetVal,
	  (SUM(case when _event_concept_name_ in ('Record Goods Receipt') THEN 1 else 0 END )-SUM(case when _event_concept_name_ in ('Cancel Goods Receipt') THEN 1 else 0 END )) AS Sum_GR,
	  (SUM(case when _event_concept_name_ in ('Record Invoice Receipt') THEN 1 else 0 END )-SUM(case when _event_concept_name_ in ('Cancel Invoice Receipt') THEN 1 else 0 END )) AS Sum_IR,
SUM(case when _event_concept_name_ in ('Clear Invoice') THEN 1 else 0 END ) AS Sum_Payments
INTO stg.temp_3wayafter
from PROM.Event_Log_All 
where 
_case_item_category_='3-way match, invoice after GR'
group by _case_concept_name_,_case_item_category_;


-- cases compliant in 2 way without clear invoice
select * 
into stg._01_Compliant_withoutPayment_three_way_matchafter
from 
stg.temp_3wayafter 
where 
Sum_Payments<=0 and 
 CreateOrder_NetVal= (IR_NetVal-CancelIR_NetVal)
 and Sum_GR=Sum_IR
 and Sum_GR!=0
 and (IR_NetVal-CancelIR_NetVal)=(GR_NetVal-CancelGR_NetVal)
 

 -- View for the entire event log belong to above cases
CREATE VIEW 
PROM.CLUSTER_01_Compliant_withoutPayment
AS
Select T1.*
from 
PROM.Event_log_All T1
where _case_concept_name_
in (Select _case_concept_name_ from stg._01_Compliant_withoutPayment_three_way_matchafter)