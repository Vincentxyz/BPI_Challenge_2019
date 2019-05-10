select A._eventID__,A.is_material_missing,
B._event_User_,B.task_load_past_two_days,B.task_load_past_seven_days,C.resource_count_case
from DIM.event_missing_material_info A join DIM.event_resource_workload B on A._eventID__ = B._eventID__
join DIM.event_handover_of_work C on B._eventID__ = C._eventID__

-- Material missing
-- Task load of the user in the last two days
-- Task load of the user in the last seven days
-- Resource count of the users involved in that case in that event in time
