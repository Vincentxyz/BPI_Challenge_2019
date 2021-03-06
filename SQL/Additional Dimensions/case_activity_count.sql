/****** Script for SelectTopNRows command from SSMS  ******/

SELECT _case_concept_name_, MAX(sequence_number) as max_seq_no
INTO #max_seq_no_per_case
FROM [stg].[input_for_decision_tree]
GROUP BY _case_concept_name_;
Go

DROP TABLE IF EXISTS DIM.case_activity_count;
Go

SELECT [input_for_decision_tree].[_case_concept_name_]
,[SRM  Created]
      ,[SRM  Complete]
      ,[SRM  Awaiting Approval]
      ,[SRM  Document Completed]
      ,[SRM  In Transfer to Execution Syst ]
      ,[SRM  Ordered]
      ,[SRM  Change was Transmitted]
      ,[Create Purchase Order Item]
      ,[Vendor creates invoice]
      ,[Record Goods Receipt]
      ,[Record Invoice Receipt]
      ,[Clear Invoice]
      ,[Record Service Entry Sheet]
      ,[SRM  Transfer Failed (E Sys )]
      ,[Cancel Goods Receipt]
      ,[Vendor creates debit memo]
      ,[Cancel Invoice Receipt]
      ,[Change Delivery Indicator]
      ,[Remove Payment Block]
      ,[SRM  Deleted]
      ,[Change Price]
      ,[Delete Purchase Order Item]
      ,[SRM  Transaction Completed]
      ,[Change Quantity]
      ,[Change Final Invoice Indicator]
      ,[SRM  Incomplete]
      ,[SRM  Held]
      ,[Cancel Subsequent Invoice]
      ,[Record Subsequent Invoice]
      ,[Receive Order Confirmation]
      ,[Reactivate Purchase Order Item]
      ,[Update Order Confirmation]
      ,[Block Purchase Order Item]
      ,[Change Approval for Purchase Order]
      ,[Release Purchase Order]
      ,[Set Payment Block]
      ,[Create Purchase Requisition Item]
      ,[Change Storage Location]
      ,[Change Currency]
      ,[Change payment term]
      ,[Change Rejection Indicator]
      ,[Release Purchase Requisition]
INTO DIM.case_activity_count
  FROM [stg].[input_for_decision_tree]
JOIN #max_seq_no_per_case
ON [input_for_decision_tree]._case_concept_name_ = #max_seq_no_per_case._case_concept_name_
AND [input_for_decision_tree].sequence_number = #max_seq_no_per_case.max_seq_no