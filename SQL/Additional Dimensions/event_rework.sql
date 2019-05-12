SELECT _case_concept_name_,
	   _event_concept_name_,
	   _eventID__,
	    CASE WHEN _event_concept_name_ in ('Change Price','Change Quantity','Cancel Invoice Receipt',
									'Cancel Goods Receipt','Delete Purchase Order Item',
									'Change Approval for Purchase Order','Change Currency','Change payment term',
									'Change Final Invoice Indicator','Change Delivery Indicator',
									'Change Rejection Indicator','Change Storage Location',
									'Cancel Subsequent Invoice') THEN 1
		ELSE 0 END AS is_rework
INTO DIM.event_rework
FROM stg.event_table_filtered

