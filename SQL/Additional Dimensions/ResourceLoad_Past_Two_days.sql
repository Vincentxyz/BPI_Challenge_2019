/****** Script for SelectTopNRows command from SSMS  ******/

-- Self join event table
-- group by users
-- timestamp of the events should fall in the past 2 days
-- display the count of records
select A._event_User_,A._event_time_timestamp_,count(*) as [TaskLoad_PastTwoDays] 
from  stg.event_table A
join stg.event_table B 
on A._eventID__ = B._eventID__
where A._event_User_ like 'user%' and B._event_User_ like ('user%') 
and A._event_time_timestamp_ between B._event_time_timestamp_ and DATEADD(day,2,B._event_time_timestamp_)
group by A._event_User_ ,A._event_time_timestamp_
having count(*) > 0
order by A._event_time_timestamp_
