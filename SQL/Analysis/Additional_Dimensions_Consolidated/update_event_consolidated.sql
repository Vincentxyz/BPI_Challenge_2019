update t1
set t1.SUM_GR = t2.Sum_GR,
t1.SUM_IR = t2.Sum_IR,
t1.Deviation = t2.Deviation,
t1.CreateOrder_NetVal = t2.CreateOrder_NetVal,
t1.GR_NetVal = t2.GR_NetVal,
t1.IR_NetVal = t2.IR_NetVal,
t1.CancelGR_NetVal = t2.CancelGR_NetVal,
t1.CancelIR_NetVal = t2.CancelIR_NetVal
from DIM.event_consolidated_dimensions t1
    inner join stg.case_compliance t2 on
      t1._case_concept_name_ = t2._case_concept_name_
	  where t2.is_complete = 1