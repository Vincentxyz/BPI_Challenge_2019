Select 
[_case_concept_name_],
(SUM(case when _event_concept_name_ in ('Create Purchase Order Item') THEN CAST([_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as CreateOrder_NetVal,
(SUM(case when _event_concept_name_ in ('Record Invoice Receipt') THEN CAST([_event_Cumulative_net_worth__EUR__] AS float) else 0 END )) as IR_NetVal,
SUM(case when _event_concept_name_ in ('Clear Invoice') THEN 1 else 0 END ) AS Sum_Payments
INTO stg.temp_2way
from PROM.Event_Log_All 
where 
_case_item_category_='2-way match'
group by _case_concept_name_,_case_item_category_;


-- cases compliant in 2 way without clear invoice
select _case_concept_name_ 
into stg._03_Compliant_withoutPayment_Two_way_match
from 
stg.temp_2way 
where 
Sum_Payments<=0 and 
 CreateOrder_NetVal= IR_NetVal

 -- View for the entire event log belong to above cases
CREATE VIEW 
PROM.CLUSTER_03_Compliant_withoutPayment_Two_way_match
AS
Select T1.*
from 
PROM.Event_log_All T1
where _case_concept_name_
in (Select _case_concept_name_ from stg._03_Compliant_withoutPayment_Two_way_match)