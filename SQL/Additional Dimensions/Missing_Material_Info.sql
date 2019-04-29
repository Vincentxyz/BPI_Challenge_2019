-- Find all events happened against cases which has no value in the fields, Spend_area_text and sub_spend_area_text
--indicating missing information about the department and material ordered.

Go

Insert into [DIM].[event_missing_material_info]
select A._eventID__,
		A._case_concept_name_,
		A._event_concept_name_,
		CASE WHEN B._case_Spend_area_text_ like '' or B._case_Sub_spend_area_text_ like '' THEN 1
		 ELSE 0 END		AS is_material_missing,
		B._case_Spend_area_text_,
		B._case_Sub_spend_area_text_,
		B._case_Spend_classification_text_
from stg.event_table_filtered A join stg.case_table_filtered B 
on A._case_concept_name_ = B._case_concept_name_;
Go