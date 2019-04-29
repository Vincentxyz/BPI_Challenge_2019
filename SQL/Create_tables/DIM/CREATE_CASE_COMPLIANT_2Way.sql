SELECT  T2.*
  INTO DIM.case_compliant_2way
  FROM DIM.case_compliance T1,
  dbo.OriginData T2
  WHERE  T1._case_concept_name_=T2._case_concept_name_ and
  T1._case_item_category_='2-way match' and
  T1.CreateOrder_NetVal=(T1.IR_NetVal-T1.CancelIR_NetVal)