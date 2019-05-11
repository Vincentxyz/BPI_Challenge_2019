select _case_Purchasing_Document_, _case_Spend_area_text_ ,ROW_NUMBER() over(partition by _case_Purchasing_Document_
order by _case_Spend_area_text_) as material_count into #case_multiple_material_one_po
 from stg.case_table_filtered
group by _case_Purchasing_Document_,_case_Spend_area_text_

SELECT _case_Purchasing_Document_, MAX(material_count) AS max_material_count
INTO DIM.case_multiple_material_one_po_new
FROM #case_multiple_material_one_po
group by _case_Purchasing_Document_,material_count

