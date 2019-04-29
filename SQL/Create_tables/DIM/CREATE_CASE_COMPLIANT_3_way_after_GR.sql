SELECT  T2.*
 INTO DIM.case_compliant_3way_invoice_after_GR
  FROM DIM.case_compliance T1,
  PROM.Event_log_All T2
  WHERE  T1._case_concept_name_=T2._case_concept_name_ and
  T1._case_item_category_='3-way match, invoice after GR' and
  is_compliant = 1