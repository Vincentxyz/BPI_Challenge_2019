drop table DIM.event_consolidated_dimensions

select A.resource_count_case,C.is_material_missing,D.Open_POIs_at_the_moment,
D.Open_POIs_at_the_moment,E.task_load_past_seven_days,E.task_load_past_seven_days,
F.event_retrospective_POI,G.is_rework,G.rework_count,
H.create_poi_and_gr,H.create_poi_and_ir,
I.sequence_number,I.throughput,
X.CreateOrder_NetVal,
Y._case_Document_Type_,Y._case_Item_Type_,Y._case_Item_Category_,Y._case_Spend_classification_text_

into DIM.event_consolidated_dimensions
from stg.event_compliance X 
join stg.case_table_filtered Y on Y._case_concept_name_ = X._case_concept_name_
join DIM.event_handover_of_work A
join DIM.event_missing_material_info C on C._eventID__ = X._event_ID__
join DIM.event_open_po_items D on D._event_ID__ = X._event_ID__
join DIM.event_resource_workload E on E._eventID__ = X._event_ID__
join DIM.event_retrospective_po_items F on F._eventID__ = X._event_ID__
--join DIM.event_rework G on G._eventID__ = X._event_ID__
join DIM.event_rework_count G on G._eventID__ = X._event_ID__
join DIM.event_segregation_of_duty H on H._event_ID__ = X._event_ID__
join DIM.event_throughput_time I on I._eventID__ = X._event_ID__
where X.is_complete = 1



--add process cluster to event dimensions
update T1
set T1.is_complete  = T2.is_complete
from DIM.event_consolidated_dimensions T1
join stg.case_compliance T2
on T1._case_concept_name_ = T2._case_concept_name_
where T2.is_complete = 1