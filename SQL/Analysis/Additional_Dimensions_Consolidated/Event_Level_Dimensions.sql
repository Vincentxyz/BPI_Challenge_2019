select A._eventID__,A._event_concept_name_,A._case_concept_name_,A._event_User_,A.resource_count_case,
	B._case_Spend_area_text_,B.is_material_missing	,
	C.event_retrospective_POI,
	--D.task_load_past_two_days,D.task_load_past_seven_days,
	E.is_rework
into DIM.event_consolidated_dimensions
from DIM.event_handover_of_work A join DIM.event_missing_material_info B on A._eventID__ = B._eventID__
join DIM.event_retrospective_po_items C on B._eventID__ = C._eventID__
--join DIM.event_resource_workload D on C._eventID__ = D._eventID__
join DIM.event_rework E on C._eventID__ = E._eventID__