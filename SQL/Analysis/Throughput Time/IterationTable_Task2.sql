-- Table for all cases with iteration number and sequence number

Select  _case_concept_name_,
		_case_Item_Category_,
		_event_ID__, 
        _event_concept_name_, 
		_event_time_timestamp_,
		Row_Number() Over (Partition By _case_concept_name_, _event_concept_name_ Order By _event_ID__ Asc) As iteration_no,
		Row_Number() Over (Partition By _case_concept_name_ Order By _event_ID__ Asc) As sequence_no
INTO stg.event_sequence
From PROM.Event_log_All 
where _case_Item_Category_ in ('3-way match, invoice after GR','3-way match, invoice before GR')

