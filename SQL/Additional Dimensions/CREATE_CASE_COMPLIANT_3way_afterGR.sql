SELECT  T2.*
 INTO DIM.case_compliant_3way_invoice_afterGR_final
  FROM DIM.case_compliance T1,
  PROM.Event_log_All T2
  WHERE  T1._case_concept_name_=T2._case_concept_name_ and
  T1._case_item_category_='3-way match, invoice after GR' and
  T1.CreateOrder_NetVal=(T1.IR_NetVal-T1.CancelIR_NetVal)
  and (T1.IR_NetVal-T1.CancelIR_NetVal)=(T1.GR_NetVal-T1.CancelGR_NetVal)
  and T1.Deviation=0
  and T1.Sum_GR!=0