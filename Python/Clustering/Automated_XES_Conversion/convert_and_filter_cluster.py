import pandas as pd
from pm4py.objects.log.importer.csv import factory as csv_importer
from pm4py.objects.conversion.log import factory as conversion_factory



path = 'C:/Users/vince_000/Documents/BPI Challenge 2019/Exports/'

file = 'CLUSTER_01_01_01_ALL_INV_after_GR_with_SRM_Service.txt'

try:
    pd_file = pd.read_csv(path + file, encoding = 'utf-16')
except:
    pd_file = pd.read_csv(path + file, encoding = 'utf-8')

try:
    col_case_concept_name = pd_file.columns.get_loc('_case_concept_name_')
    pd_file.columns.values[col_case_concept_name] = 'case:concept:name'
except:
    print('Did not find _case_concept_name_')
    
try:
    col_event_concept_name = pd_file.columns.get_loc('_event_concept_name_')
    pd_file.columns.values[col_event_concept_name]= 'concept:name'
except:
    print('Did not find _case_concept_name_')    
    

try:
    col_time_timestamp = pd_file.columns.get_loc('_event_time_timestamp_')
    pd_file.columns.values[col_time_timestamp]= 'time:timestamp'
except:
    print('Did not find _event_time_stamp_')    

pd_file_filtered = pd_file.filter(items = ['case:concept:name', 'concept:name', 'time:timestamp'])

pd_file_filtered.to_csv(path + file + '_2', encoding = 'utf-8', index = False)


event_stream = csv_importer.import_event_stream(path = path + file + '_2', parameters = {"sort" : True,"sort_field" :"time:timestamp"})


    
log = conversion_factory.apply(event_stream, parameters= {"timestamp_sort": True})



####### Filter the event log

## Start activities

from pm4py.algo.filtering.log.start_activities import start_activities_filter

log_start = start_activities_filter.get_start_activities(log)


log = start_activities_filter.apply_auto_filter(log, parameters={"decreasingFactor": 0.6})
print(start_activities_filter.get_start_activities(log))

## End activities

from pm4py.algo.filtering.log.end_activities import end_activities_filter

log_end = end_activities_filter.get_end_activities(log)

log_af_ea = end_activities_filter.apply_auto_filter(log, parameters={"decreasingFactor": 0.6})
print(end_activities_filter.get_end_activities(log_af_ea))

## Other Events

from pm4py.algo.filtering.log.attributes import attributes_filter
from pm4py.util import constants
log = attributes_filter.apply_auto_filter(log, parameters={
    constants.PARAMETER_CONSTANT_ATTRIBUTE_KEY: "concept:name", "decreasingFactor": 0.6})

activities = attributes_filter.get_attribute_values(log, "concept:name")    
    
auto_filtered_activities = attributes_filter.get_attribute_values(log, "concept:name")    

    
# Entire variants

from pm4py.algo.filtering.log.variants import variants_filter

variants = variants_filter.get_variants(log)
    
log = variants_filter.apply_auto_filter(log)

auto_variants = variants_filter.get_variants(auto_filtered_log)

# Export the log

from pm4py.objects.log.exporter.xes import factory as xes_exporter

xes_exporter.export_log(log, "C:/Users/vince_000/Documents/BPI Challenge 2019/Exports/exportedLog_2.xes")

log[0]
