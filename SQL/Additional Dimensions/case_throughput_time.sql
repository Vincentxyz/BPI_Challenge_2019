/****** Script for SelectTopNRows command from SSMS  ******/
DROP TABLE IF EXISTS #max_seq_no_per_case, DIM.case_throughput_time;
Go

SELECT _case_concept_name_, MAX(sequence_number) as max_seq_no
INTO #max_seq_no_per_case
FROM DIM.event_throughput_time
GROUP BY _case_concept_name_;
Go

SELECT [event_throughput_time].[_case_concept_name_]
      ,[throughput] AS throughput_time_in_h
	  ,throughput / 24.0 AS throughput_time_in_d
INTO DIM.case_throughput_time
  FROM [DIM].[event_throughput_time]
JOIN #max_seq_no_per_case
ON [event_throughput_time]._case_concept_name_ = #max_seq_no_per_case._case_concept_name_
AND [event_throughput_time].sequence_number = #max_seq_no_per_case.max_seq_no