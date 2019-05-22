SELECT 'stg.case_compliance (ALL cases)', COUNT(*) AS row_cases
FROM stg.case_compliance

UNION

SELECT 'stg.case_compliance (COMPLETE cases)', COUNT(*) AS row_cases
FROM stg.case_compliance
WHERE is_complete = 1

UNION

SELECT 'DIM.case_handover_of_work', COUNT(*) AS row_cases
FROM DIM.case_handover_of_work

UNION

SELECT 'DIM.case_rework_count', COUNT(*) AS row_cases
FROM DIM.case_rework_count

UNION

SELECT 'DIM.case_segregation_of_duty', COUNT(*) AS row_cases
FROM DIM.case_segregation_of_duty

UNION

SELECT 'DIM.case_multiple_material_one_po', COUNT(*) AS row_cases
FROM DIM.case_multiple_material_one_po

UNION

SELECT 'DIM.case_retrospective_po_items', COUNT(*) AS row_cases
FROM DIM.case_retrospective_po_items

UNION

SELECT 'DIM.case_throughput_time', COUNT(*)
FROM DIM.case_throughput_time

UNION

SELECT 'DIM.case_number_of_orders_created_same_day_and_vendor', COUNT(*)
FROM DIM.case_number_of_orders_created_same_day_and_vendor

UNION

SELECT 'stg.case_clustering', COUNT(*)
FROM [stg].[case_clustering]

UNION

SELECT 'DIM.case_missing_material_info', COUNT(*)
FROM DIM.case_missing_material_info