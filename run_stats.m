function run_stats

file_name = 'StringPulling_AvgVelocity.xlsx';

[num,txt,raw] = xlsread(file_name,2,'C14:H19');

n = 0;

[within,dvn,xlabels] = make_within_table({'Days'},[5]);
xlabels = txt(2:6);
between = make_between_table({num(:,2:6)},dvn);

ra = repeatedMeasuresAnova(between,within);

colormaps = load('../Common/Matlab/colorblind_colormap.mat');
colormaps.colorblind = flipud(colormaps.colorblind);
mData.colors = mat2cell(colormaps.colorblind,[ones(1,size(colormaps.colorblind,1))]);%{[0 0 0],[0.1 0.7 0.3],'r','b','m','c','g','y'}; % mData.colors = getColors(10,{'w','g'});
% %%
% hf = figure(6);clf;set(gcf,'Units','Inches');set(gcf,'Position',[5 7 2 1],'color','w');
% hold on;
% [xdata,mVar,semVar,combs,p,h,colors,hollowsep] = get_vals_for_line_graph(mData,ra,0);
% tcolors = mData.colors;
% ii = 1; plot(xdata,mVar(ii,:),'color',tcolors{ii},'linewidth',0.5); errorbar(xdata,mVar(ii,:),semVar(ii,:),'color',colors{ii},'linewidth',0.25,'linestyle','none','capsize',1);
% set(gca,'xtick',xdata,'xticklabel',xlabels);
% set_axes_limits(gca,[xdata(1)-0.5,xdata(end)+0.5],[])

%% Mutual Information Time versus Distance bar graph
[xdata,mVar,semVar,combs,p,h,colors,hollowsep] = get_vals_for_bar_graph(mData,ra,0,[1 0.25 1]);
hf = figure(5);clf;set(gcf,'Units','Inches');set(gcf,'Position',[5 7 3 1],'color','w');
hold on;
% tcolors = repmat(tcolors,2,1)';
[hbs,maxY] = plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
    'ySpacing',0.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.01,...
    'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',8,'barWidth',0.5,'sigLinesStartYFactor',0.01);
set(gca,'xlim',[0.35 xdata(end)+.65],'ylim',[0 maxY],'FontSize',6,'FontWeight','Normal','TickDir','out','xcolor','k','ycolor','k');
xticks = xdata; xticklabels = {'C3-D','C4-D','C3''-D','C3-T','C4-T','C3''-T'}; xticklabels = repmat(xticklabels,1,2);
set(gca,'xtick',xticks,'xticklabels',xticklabels);
xtickangle(45)
changePosition(gca,[0.05 0.02 -0.05 -0.011])
put_axes_labels(gca,{[],[0 0 0]},{{'zMI'},[0 0 0]});

save_pdf(hf,mData.pdf_folder,'zMI_bar_graph_all_cells.pdf',600);
