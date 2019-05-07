DROP TABLE IF EXISTS  stg.cluster_id;
Go

CREATE TABLE stg.cluster_id (
"cluster_id" NVARCHAR(100),
"cluster_name" NVARCHAR(100)
)
Go 

CREATE INDEX ix_cluster_id ON stg.cluster_id (cluster_id);
Go

DROP TABLE IF EXISTS  stg.case_clustering;
Go

CREATE TABLE stg.case_clustering (
"_case_concept_name_" NVARCHAR(100) PRIMARY KEY,
"level_1_cluster_id" NVARCHAR(100),
"level_2_cluster_id" NVARCHAR(100),
"level_3_cluster_id" NVARCHAR(100)
);
Go 

INSERT INTO stg.case_clustering (
_case_concept_name_
) SELECT
_case_concept_name_
FROM stg.case_table_filtered;
Go

CREATE INDEX ix_case_clustering
ON stg.case_clustering
(
	_case_concept_name_
)
GO


-- Level 1 cluster_id

INSERT INTO stg.cluster_id 
VALUES (
'01',
'3-way match, invoice after GR'
);
Go

INSERT INTO stg.cluster_id 
VALUES (
'02',
'3-way match, invoice before GR'
);
Go

INSERT INTO stg.cluster_id 
VALUES (
'03',
'2-way match'
);
Go

INSERT INTO stg.cluster_id 
VALUES (
'04',
'Consignment'
);
Go

-- Level 2 cluster_id

DELETE FROM stg.case_clustering
WHERE _case_concept_name_ IN 
(SELECT _case_concept_name_ FROM stg.excluded_cases);
Go

INSERT INTO stg.cluster_id 
VALUES (
'01_01',
'3-way match, invoice after GR (with SRM)'
);
Go

INSERT INTO stg.cluster_id 
VALUES (
'01_02',
'3-way match, invoice after GR (without SRM)'
);
Go

INSERT INTO stg.cluster_id 
VALUES (
'02_01',
'3-way match, invoice before GR (with SRM)'
);
Go

INSERT INTO stg.cluster_id 
VALUES (
'02_02',
'3-way match, invoice before GR (without SRM)'
);
Go


-- Level 3 cluster_id

INSERT INTO stg.cluster_id 
VALUES (
'01_01_01',
'3-way match, invoice after GR (with SRM; Item Type: Service)'
);
Go

INSERT INTO stg.cluster_id 
VALUES (
'01_01_02',
'3-way match, invoice after GR (without SRM, Item Type: Standard)'
);
Go

INSERT INTO stg.cluster_id 
VALUES (
'01_02_01',
'3-way match, invoice after GR (without SRM; Item Type: Service)'
);
Go

INSERT INTO stg.cluster_id 
VALUES (
'01_02_02',
'3-way match, invoice after GR (without SRM, Item Type: Standard)'
);
Go

INSERT INTO stg.cluster_id 
VALUES (
'01_02_03',
'3-way match, invoice after GR (without SRM, Item Type: Subcontracting and Third-Party)'
);
Go

INSERT INTO stg.cluster_id 
VALUES (
'02_02_01',
'3-way match, invoice before GR (without SRM, Item Type: Standard)'
);
Go

INSERT INTO stg.cluster_id 
VALUES (
'02_02_02',
'3-way match, invoice before GR (without SRM, Item Type: Subcontracting)'
);
Go

INSERT INTO stg.cluster_id 
VALUES (
'02_02_03',
'3-way match, invoice before GR (without SRM, Item Type: Third-Party)'
);
Go

-- Level 1 case_clustering

UPDATE stg.case_clustering SET level_1_cluster_id = '01'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
JOIN stg.event_table ON
event_table._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice after GR'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'true'
AND case_table_filtered._case_Goods_Receipt_ = 'true';
Go

UPDATE stg.case_clustering SET level_1_cluster_id = '02'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
JOIN stg.event_table ON
event_table._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice before GR'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'false'
AND case_table_filtered._case_Goods_Receipt_ = 'true';
Go

UPDATE stg.case_clustering SET level_1_cluster_id = '03'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
JOIN stg.event_table ON
event_table._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '2-way match'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'false'
AND case_table_filtered._case_Goods_Receipt_ = 'false';
Go

UPDATE stg.case_clustering SET level_1_cluster_id = '04'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
JOIN stg.event_table ON
event_table._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = 'Consignment'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'false'
AND case_table_filtered._case_Goods_Receipt_ = 'true';
Go

-- Level 2 case_clustering

UPDATE stg.case_clustering SET level_2_cluster_id = '01_01'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
JOIN stg.event_table ON
event_table._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice after GR'
AND event_table._event_concept_name_ like '%SRM:%'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'true'
AND case_table_filtered._case_Goods_Receipt_ = 'true';
Go


UPDATE stg.case_clustering SET level_2_cluster_id = '01_02'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice after GR'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'true'
AND case_table_filtered._case_Goods_Receipt_ = 'true'
AND case_table_filtered._case_concept_name_ NOT IN 
(SELECT DISTINCT _case_concept_name_ FROM stg.event_table_filtered
WHERE event_table_filtered._event_concept_name_  like '%SRM:%');
Go

UPDATE stg.case_clustering SET level_2_cluster_id = '02_01'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
JOIN stg.event_table_filtered ON
event_table_filtered._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice before GR'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'false'
AND case_table_filtered._case_Goods_Receipt_ = 'true'
AND event_table_filtered._event_concept_name_ like '%SRM:%';
Go

UPDATE stg.case_clustering SET level_2_cluster_id = '02_02'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice before GR'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'false'
AND case_table_filtered._case_Goods_Receipt_ = 'true'
AND case_table_filtered._case_concept_name_ NOT IN 
(SELECT DISTINCT _case_concept_name_ FROM stg.event_table_filtered
WHERE event_table_filtered._event_concept_name_  like '%SRM:%');
Go

-- Level 3 Clustering

UPDATE stg.case_clustering SET level_3_cluster_id = '01_01_01'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
JOIN stg.event_table ON
event_table._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice after GR'
AND event_table._event_concept_name_ like '%SRM:%'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'true'
AND case_table_filtered._case_Goods_Receipt_ = 'true'
AND case_table_filtered._case_Item_Type_ = 'Service';

UPDATE stg.case_clustering SET level_3_cluster_id = '01_01_02'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
JOIN stg.event_table ON
event_table._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice after GR'
AND event_table._event_concept_name_ like '%SRM:%'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'true'
AND case_table_filtered._case_Goods_Receipt_ = 'true'
AND case_table_filtered._case_Item_Type_ = 'Standard';

UPDATE stg.case_clustering SET level_3_cluster_id = '01_02_01'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice after GR'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'true'
AND case_table_filtered._case_Goods_Receipt_ = 'true'
AND case_table_filtered._case_concept_name_ NOT IN 
(SELECT DISTINCT _case_concept_name_ FROM stg.event_table_filtered
WHERE event_table_filtered._event_concept_name_  like '%SRM:%')
AND case_table_filtered._case_Item_Type_ = 'Service';
Go

UPDATE stg.case_clustering SET level_3_cluster_id = '01_02_02'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice after GR'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'true'
AND case_table_filtered._case_Goods_Receipt_ = 'true'
AND case_table_filtered._case_concept_name_ NOT IN 
(SELECT DISTINCT _case_concept_name_ FROM stg.event_table_filtered
WHERE event_table_filtered._event_concept_name_  like '%SRM:%')
AND case_table_filtered._case_item_type_ = 'Standard';
Go

UPDATE stg.case_clustering SET level_3_cluster_id = '01_02_03'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice after GR'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'true'
AND case_table_filtered._case_Goods_Receipt_ = 'true'
AND case_table_filtered._case_concept_name_ NOT IN 
(SELECT DISTINCT _case_concept_name_ FROM stg.event_table_filtered
WHERE event_table_filtered._event_concept_name_  like '%SRM:%')
AND case_table_filtered._case_item_type_ IN ('Subcontracting', 'Third-Party');
Go

UPDATE stg.case_clustering SET level_3_cluster_id = '02_02_01'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice before GR'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'false'
AND case_table_filtered._case_Goods_Receipt_ = 'true'
AND case_table_filtered._case_concept_name_ NOT IN 
(SELECT DISTINCT _case_concept_name_ FROM stg.event_table_filtered
WHERE event_table_filtered._event_concept_name_  like '%SRM:%')
AND case_table_filtered._case_item_type_ = 'Standard';
Go

UPDATE stg.case_clustering SET level_3_cluster_id = '02_02_02'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice before GR'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'false'
AND case_table_filtered._case_Goods_Receipt_ = 'true'
AND case_table_filtered._case_concept_name_ NOT IN 
(SELECT DISTINCT _case_concept_name_ FROM stg.event_table_filtered
WHERE event_table_filtered._event_concept_name_  like '%SRM:%')
AND case_table_filtered._case_item_type_ = 'Subcontracting';
Go

UPDATE stg.case_clustering SET level_3_cluster_id = '02_02_03'
FROM stg.case_clustering 
JOIN stg.case_table_filtered ON
case_clustering._case_concept_name_ = case_table_filtered._case_concept_name_
WHERE case_table_filtered._case_Item_Category_ = '3-way match, invoice before GR'
AND case_table_filtered._case_GR_Based_Inv__Verif__ = 'false'
AND case_table_filtered._case_Goods_Receipt_ = 'true'
AND case_table_filtered._case_concept_name_ NOT IN 
(SELECT DISTINCT _case_concept_name_ FROM stg.event_table_filtered
WHERE event_table_filtered._event_concept_name_  like '%SRM:%')
AND case_table_filtered._case_item_type_ = 'Third-Party';
Go

UPDATE stg.case_clustering SET final_cluster =  CASE 
		WHEN level_3_cluster_id IS NOT NULL THEN level_3_cluster_id
		WHEN level_2_cluster_id IS NOT NULL THEN level_2_cluster_id
		WHEN level_1_cluster_id IS NOT NULL THEN level_1_cluster_id
		ELSE 'NA'
		END;
		Go

