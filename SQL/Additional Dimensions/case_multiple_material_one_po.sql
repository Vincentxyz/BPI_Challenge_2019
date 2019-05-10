select _case_Purchasing_Document_, _case_Spend_area_text_ ,ROW_NUMBER() over(partition by _case_Purchasing_Document_
order by _case_Spend_area_text_) as material_count into DIM.case_multiple_material_one_po
 from stg.case_table
group by _case_Purchasing_Document_,_case_Spend_area_text_


