function run_stats

file_name = 'StringPulling_AvgVelocity.xlsx';

[num,txt,raw] = xlsread(file_name,2,'C14:H19');

n = 0;

[within,dvn,xlabels] = make_within_table({'Days'},[]);

