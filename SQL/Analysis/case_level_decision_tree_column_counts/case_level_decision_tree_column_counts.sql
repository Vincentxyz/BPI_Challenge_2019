SELECT COUNT(*)
FROM stg.case_compliance
WHERE is_complete = 1

SELECT COUNT(*)
FROM DIM.case_handover_of_work

SELECT _case_concept_name_
FROM DIM.case_rework_count
GROUP BY _case_concept_name_
HAVING COUNT(*) > 1

SELECT COUNT(*)
FROM DIM.case_segregation_of_duty


SELECT COUNT(*)
FROM DIM.case_multiple_material_one_po

SELECT COUNT(*)
FROM DIM.case_retrospective_po_items

SELECT COUNT(*)
FROM DIM.case_throughput_time

SELECT COUNT(*)
FROM DIM.case_number_of_orders_created_same_day_and_vendor