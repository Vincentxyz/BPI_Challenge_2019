/****** Script for SelectTopNRows command from SSMS  ******/

SELECT _case_concept_name_, MAX(sequence_number) as max_seq_no
INTO #max_seq_no_per_case
FROM DIM.event_throughput_time
GROUP BY _case_concept_name_;
Go

SELECT [event_throughput_time].[_case_concept_name_]
      ,[throughput]
INTO DIM.case_throughput_time
  FROM [DIM].[event_throughput_time]
JOIN #max_seq_no_per_case
ON [event_throughput_time]._case_concept_name_ = #max_seq_no_per_case._case_concept_name_