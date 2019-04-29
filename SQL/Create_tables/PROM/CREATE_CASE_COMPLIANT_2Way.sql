SELECT  T2.*
  INTO DIM.case_compliant_2way
  FROM DIM.case_compliance T1,
  dbo.PROM.Event_Log_All T2
  WHERE  T1._case_concept_name_=T2._case_concept_name_ and
  T1._case_item_category_='2-way match' and
  T2.is_compliant = 1