
SELECT COUNT(*) FROM  stg.event_compliance X;
Go

SELECT COUNT(*) FROM  DIM.event_handover_of_work X;
Go

SELECT COUNT(*) FROM DIM.event_rework_count;
Go

SELECT COUNT(*) FROM DIM.event_retrospective_po_items;
Go

SELECT COUNT(*) FROM DIM.event_segregation_of_duty;
Go

SELECT COUNT(*) FROM DIM.event_segregation_of_duty;
Go

SELECT COUNT(*) FROM DIM.event_throughput_time;
Go

SELECT COUNT(*) FROM DIM.event_number_of_orders_created_same_day_and_vendor;
Go

SELECT COUNT(*) FROM DIM.event_number_of_orders_created_same_day_and_vendor;
Go

join stg.case_clustering K on X._case_concept_name_ = K._case_concept_name_