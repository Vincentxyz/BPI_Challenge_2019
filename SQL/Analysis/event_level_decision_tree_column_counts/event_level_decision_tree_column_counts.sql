SELECT 'stg.event_compliance (events from ALL cases)' AS sql_table, COUNT(*) AS row_count FROM  stg.event_compliance X

UNION

SELECT 'stg.event_compliance (events from COMPLETE cases)' AS sql_table, COUNT(*) AS row_count FROM  stg.event_compliance X
WHERE is_complete = 1

UNION

SELECT 'DIM.event_handover_usercount' AS sql_table, COUNT(*) AS row_count FROM  DIM.event_handover_usercount X

UNION

SELECT 'DIM.event_rework_count' AS sql_table, COUNT(*) AS row_count FROM DIM.event_rework_count

UNION

SELECT 'DIM.event_resource_workload' AS sql_table, COUNT(*) AS row_count FROM DIM.event_resource_workload

UNION

SELECT 'DIM.event_retrospective_po_items' AS sql_table, COUNT(*) AS row_count FROM DIM.event_retrospective_po_items

UNION

SELECT 'DIM.event_segregation_of_duty' AS sql_table, COUNT(*) AS row_count  FROM DIM.event_segregation_of_duty

UNION

SELECT 'DIM.event_throughput_time' AS sql_table, COUNT(*) AS row_count FROM DIM.event_throughput_time

UNION

SELECT 'DIM.event_handover_usercount' AS sql_table, COUNT(*) AS row_count FROM DIM.event_handover_usercount

UNION

SELECT 'DIM.event_missing_material_info' AS sql_table, COUNT(*) AS row_count FROM DIM.event_missing_material_info

UNION

SELECT 'stg.case_clustering', COUNT(*)
FROM stg.case_clustering

UNION

SELECT 'DIM.case_multiple_material_one_po', COUNT(*)
FROM DIM.case_multiple_material_one_po
Go