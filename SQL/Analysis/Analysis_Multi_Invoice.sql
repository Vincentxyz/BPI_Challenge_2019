CREATE VIEW PROM.Multi_Invoice_Analysis AS 
SELECT 
stg.case_table_filtered.*,
CASE WHEN Sum_IR > 1 THEN 'Multiple_Invoices'
WHEN Sum_IR = 1 THEN 'One_Invoice'
WHEN Sum_IR = 0 THEN 'No_Invoice' END AS 'Invoice_Quantity'
FROM stg.case_table_filtered
JOIN stg.case_compliance ON case_table_filtered._case_concept_name_ = case_compliance._case_concept_name_

