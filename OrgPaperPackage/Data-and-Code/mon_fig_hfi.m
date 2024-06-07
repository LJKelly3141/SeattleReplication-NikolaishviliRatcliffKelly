[hfi] = xlsread('mon_fig_hfi.xlsx',1);
hfidata = hfi(:,2)/std(hfi(:,2));
dn = hfi(:,1);

fig = figure;
hold on
plot(dn,hfidata,'k','Linewidth',0.5,'Linestyle','-','Marker','o','Markeredgecolor','k','Markerfacecolor','w');
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',82); % 2008-10
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',83); % 2008-11
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',118); % 2011-10
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',119); % 2011-11
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',11); % 2002-11
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',12); % 2002-12
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',15); % 2003-03
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',18); % 2003-06
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',84); % 2008-12
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',85); % 2009-01
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',87); % 2009-03
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',88); % 2009-04
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',127); % 2012-07
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',153); % 2014-09
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',168); % 2015-12
datetick('x','keeplimits');
xlim([dn(1) dn(end)]);
set(gca,'xtick',[dn(13):(dn(13+48)-dn(13)):dn(end)])
set(gca,'xticklabel',["2003" "2007" "2011" "2015" "2019"])
ylabel('Change in basis points')
set(gcf,'papersize',[15 15])
print('-fillpage','-dpdf','mon_fig_hfi')
