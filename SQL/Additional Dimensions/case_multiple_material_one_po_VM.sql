DROP TABLE  IF EXISTS #case_multiple_material_one_po;
Go

DROP TABLE  IF EXISTS #case_multiple_material_one_po_po_level;
Go

DROP TABLE  IF EXISTS DIM.case_multiple_material_one_po;
Go

select _case_Purchasing_Document_, _case_Spend_area_text_ ,ROW_NUMBER() over(partition by _case_Purchasing_Document_
order by _case_Spend_area_text_) as material_count into #case_multiple_material_one_po
 from stg.case_table_filtered
group by _case_Purchasing_Document_,_case_Spend_area_text_

SELECT _case_Purchasing_Document_, MAX(material_count) AS max_material_count
INTO #case_multiple_material_one_po_po_level
FROM #case_multiple_material_one_po
group by _case_Purchasing_Document_,material_count

SELECT _case_concept_name_, max_material_count AS material_count
INTO DIM.case_multiple_material_one_po
FROM stg.case_table_filtered
JOIN #case_multiple_material_one_po_po_level
ON case_table_filtered._case_Purchasing_Document_ = #case_multiple_material_one_po_po_level._case_Purchasing_Document_


