function run_stats_vel

colormaps = load('../../Common/Matlab/colorblind_colormap.mat');
colormaps.colorblind = flipud(colormaps.colorblind);
mData.colors = mat2cell(colormaps.colorblind,[ones(1,size(colormaps.colorblind,1))]);%{[0 0 0],[0.1 0.7 0.3],'r','b','m','c','g','y'}; % mData.colors = getColors(10,{'w','g'});
mData.pdf_folder = pwd;
%%

file_name = 'ANOVA spreadsheet 09-19.xlsx';
[num,txt,raw] = xlsread(file_name,1,'A136:e15014');
% file_name = 'Group Adjusted Avg_Velocity.xlsx';
% [num,txt,raw] = xlsread(file_name,1,'B3:Q14');
n = 0;
%%
% round 1
cols = [2 4];rows = [1:8 10:14];
data = num(rows,cols);
[within,dvn,xlabels] = make_within_table({'Days'},[length(cols)]);
xlabels = txt(cols);
between = make_between_table({data},dvn);

ra = RMA(between,within);
ra.xlabels = xlabels;
hf = make_graph(mData,ra);
title(sprintf('N = %d, p = %.4f',size(data,1),ra.ranova.pValue(3)));
save_pdf(hf,mData.pdf_folder,'pre_immunization_combined',600);
return;
% round 1
rows = 1:6; rows(2) = [];
cols = [2 4 6 8 10 12 14 16];
data = num1(rows,cols);
[within,dvn,xlabels] = make_within_table({'Days'},[length(cols)]);
xlabels = txt(cols);
between = make_between_table({data},dvn);

ra = repeatedMeasuresAnova(between,within);
ra.xlabels = xlabels;
hf = make_graph(mData,ra);
title(sprintf('Round 1, N = %d, p = %.4f',size(data,1),ra.ranova.pValue(3)));
save_pdf(hf,mData.pdf_folder,'adj_bar_graph_round1_1',600);

return;


%%
% round 2
cols = [2:11];
data = num2(:,cols);
[within,dvn,xlabels] = make_within_table({'Days'},[length(cols)]);
xlabels = txt(cols);
between = make_between_table({data},dvn);
ra = repeatedMeasuresAnova(between,within);
ra.xlabels = xlabels;
hf = make_graph(mData,ra);
title(sprintf('Round 2, N = %d, p = %.4f',size(data,1),ra.ranova.pValue(3)));
save_pdf(hf,mData.pdf_folder,'adj_bar_graph_round2',600);

%%
%%
% round 2
cols = [2:12]; rows = [1 3 4 5];
data = num2(rows,cols);
[within,dvn,xlabels] = make_within_table({'Days'},[length(cols)]);
xlabels = txt(cols);
between = make_between_table({data},dvn);
ra = repeatedMeasuresAnova(between,within);
ra.xlabels = xlabels;
hf = make_graph(mData,ra);
title(sprintf('Round 2, N = %d, p = %.4f',size(data,1),ra.ranova.pValue(3)));
save_pdf(hf,mData.pdf_folder,'adj_bar_graph_round2_1',600);


function hf = make_graph(mData,ra)
[xdata,mVar,semVar,combs,p,h,colors,xlabels] = get_vals_for_bar_graph_RMA(mData,ra,{'Days','hsd'},[1.25 1 1]);
% [xdata,mVar,semVar,combs,p,h,colors,hollowsep] = get_vals_for_bar_graph_RMA(mData,{'Days','hsd'},[1 0.25 1]);
hf = figure(5);clf;set(gcf,'Units','Inches');set(gcf,'Position',[5 7 3 2],'color','w');
hold on;
% tcolors = repmat(tcolors,2,1)';
[hbs,maxY] = plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
    'ySpacing',0.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.01,...
    'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',8,'barWidth',0.5,'sigLinesStartYFactor',0.01);
set(gca,'xlim',[0.35 xdata(end)+.65],'ylim',[0 maxY],'FontSize',6,'FontWeight','Normal','TickDir','out','xcolor','k','ycolor','k');
xticks = xdata; xticklabels = ra.xlabels;
set(gca,'xtick',xticks,'xticklabels',xticklabels);
xtickangle(45)
changePosition(gca,[0.05 0.02 -0.3 -0.011])
put_axes_labels(gca,{[],[0 0 0]},{{'Avg. Velocity (cm/sec)'},[0 0 0]});
