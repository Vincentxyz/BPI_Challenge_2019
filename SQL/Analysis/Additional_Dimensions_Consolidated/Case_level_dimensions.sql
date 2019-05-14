DROP TABLE IF EXISTS DIM.case_consolidated_dimensions ;
Go

select A._case_concept_name_,
	   A._case_Document_Type_,A._case_Spend_classification_text_,A._case_Item_Category_,A._case_Item_Type_,
	   A._case_Sub_spend_area_text_,A._case_Name_,A._case_Vendor_,
	   C.number_of_handovers,
	   D.count_rework,
	   F.material_count,
	   E.sod_create_poi_and_gr,
	   E.sod_create_poi_and_ir,
	   B.Sum_GR, B.Sum_IR, B.Deviation, B.CreateOrder_NetVal, B.GR_NetVal, B.IR_NetVal, B.CancelGR_NetVal, B.CancelIR_NetVal,
	   B.is_compliant

into DIM.case_consolidated_dimensions   
	   
 from stg.case_table_filtered A 
join stg.case_compliance B on A._case_concept_name_ = B._case_concept_name_
join DIM.case_handover_of_work C on B._case_concept_name_ = C._case_concept_name_
join DIM.case_rework_count D on B._case_concept_name_ = D._case_concept_name_
join DIM.case_segregation_of_duty E on B._case_concept_name_ = E._case_concept_name_
join DIM.case_multiple_material_one_po  F on B._case_concept_name_ = F._case_concept_name_
join DIM.case_retrospective_po_items G on B._case_concept_name_ = G._case_concept_name_
where B.is_complete = 1;
Go


