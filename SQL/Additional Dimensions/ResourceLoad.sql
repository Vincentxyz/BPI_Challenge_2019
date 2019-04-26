/****** Script for SelectTopNRows command from SSMS  ******/

-- Self join event table
-- group by users

-- Find the count of resource work load in the past two days and seven days based on the Event ID and Event timetamp

Insert into [DIM].[RESOURCE_WORKLOAD] 
select _eventID__,_event_User_,_event_time_timestamp_,_case_concept_name_,_event_concept_name_,
[task_load_past_two_days] = 
	(select top 1 count(*) as TaskLoad_PastTwoDays from stg.event_table A 
	where 
	 A._event_User_ = AA._event_User_ 
	and A._event_time_timestamp_ between DATEADD(dd,-2,AA._event_time_timestamp_) and AA._event_time_timestamp_
	group by A._event_User_
	),
[task_load_past_seven_days] = 
	(select top 1 count(*) as TaskLoad_PastTwoDays from stg.event_table A 
	where 
	 A._event_User_ = AA._event_User_ 
	and A._event_time_timestamp_ between DATEADD(dd,-7,AA._event_time_timestamp_) and AA._event_time_timestamp_
	group by A._event_User_
	)

from  stg.event_table AA 
where AA._event_User_ like 'user%' 
order by _event_time_timestamp_




