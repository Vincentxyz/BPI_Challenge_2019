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


pd_file.to_csv(path + file, encoding = 'utf-8', index = False)

event_stream = csv_importer.import_event_stream(path = path + file)


    
log = conversion_factory.apply(event_stream)

from pm4py.algo.discovery.alpha import factory as alpha_miner

net, initial_marking, final_marking = alpha_miner.apply(log)




from pm4py.objects.log.importer.xes import factory as xes_import_factory
xes_path = 'C:/Users/vince_000/Documents/BPI Challenge 2019/INV after GR - with SRM/01_01_01_Service/'
xes_file = '01_01_01_Invoice_after_GR_with_SRM_Service.xes'

log = xes_import_factory.apply(xes_path + xes_file)

log[0]

from pm4py.objects.log.exporter.csv import factory as csv_exporter

csv_exporter.export(log, "C:/Users/vince_000/Documents/BPI Challenge 2019/test/outputFile1.csv")

from pm4py.algo.discovery.alpha import factory as alpha_miner

net, initial_marking, final_marking = alpha_miner.apply(log)

from pm4py.visualization.petrinet import factory as pn_vis_factory

gviz = pn_vis_factory.apply(net, initial_marking, final_marking)
pn_vis_factory.view(gviz)

log[0]