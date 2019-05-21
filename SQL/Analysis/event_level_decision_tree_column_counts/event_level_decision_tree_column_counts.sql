SELECT 'stg.event_compliance (events from ALL cases)' AS sql_table, COUNT(*) AS row_count FROM  stg.event_compliance X

UNION

SELECT 'stg.event_compliance (events from COMPLETE cases)' AS sql_table, COUNT(*) AS row_count FROM  stg.event_compliance X
WHERE is_complete = 1

UNION

SELECT 'DIM.event_handover_of_work' AS sql_table, COUNT(*) AS row_count FROM  DIM.event_handover_of_work X

UNION

SELECT COUNT(*) FROM DIM.event_rework_count;
Go

SELECT COUNT(*) FROM DIM.event_resource_workload;
Go

SELECT COUNT(*) FROM DIM.event_retrospective_po_items;
Go

SELECT COUNT(*) FROM DIM.event_segregation_of_duty;
Go

SELECT COUNT(*) FROM DIM.event_throughput_time;
Go

SELECT COUNT(*) FROM DIM.event_handover_usercount;
Go

SELECT COUNT(*) FROM DIM.event_missing_material_info;
Go
