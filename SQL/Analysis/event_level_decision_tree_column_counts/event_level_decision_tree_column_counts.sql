
SELECT COUNT(*) FROM  stg.event_compliance X
WHERE is_complete = 1;
Go

SELECT COUNT(*) FROM  DIM.event_handover_of_work X;
Go

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
