[hfi] = xlsread('mon_fig_hfi.xlsx',1);
hfidata = hfi(:,2)/std(hfi(:,2));
baseSHKmedian = squeeze(median(baseSHK(:,25:end,1),1));
baseSHKmedian = baseSHKmedian/std(baseSHKmedian);

dn = hfi(:,1);

fig = figure;
hold on

plot(dn,hfidata,'color','k','Linewidth',0.5,'Linestyle','-');
plot(dn,baseSHKmedian,'color','b','Linewidth',0.5,'Linestyle','-');

plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor',[1 0.5 0],'MarkerIndices',17); % 2003-05
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[1 0.5 0],'MarkerIndices',17); % 2003-05
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor',[1 0.5 0],'MarkerIndices',79); % 2008-07
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[1 0.5 0],'MarkerIndices',79);
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor',[1 0.5 0],'MarkerIndices',112); % 2011-04
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[1 0.5 0],'MarkerIndices',112);

plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',11); % 2002-11
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',11); % 2002-11
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',12); % 2002-12
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',12); % 2002-12
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',15); % 2003-03
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',15); % 2003-03
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',18); % 2003-06
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',18); % 2003-06
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',82); % 2008-10
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',82); % 2008-10
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',83); % 2008-11
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',83); % 2008-11
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',84); % 2008-12
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',84); % 2008-12
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',85); % 2009-01
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',85); % 2009-01
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',87); % 2009-03
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',87); % 2009-03
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',88); % 2009-04
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',88); % 2009-04
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',118); % 2011-10
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',118); % 2011-10
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',119); % 2011-11
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',119); % 2011-11
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',127); % 2012-07
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',127); % 2012-07
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',153); % 2014-09
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor',[0.75 0.75 1],'MarkerIndices',153); % 2014-09
plot(dn,baseSHKmedian,'d','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',168); % 2015-12
plot(dn,hfidata,'o','Markeredgecolor','k','MarkerFaceColor','b','MarkerIndices',168); % 2015-12

datetick('x','keeplimits');
xlim([dn(1) dn(end)]);
set(gca,'xtick',[dn(13):(dn(13+48)-dn(13)):dn(end)])
set(gca,'xticklabel',["2003" "2007" "2011" "2015" "2019"])
set(gcf,'papersize',[15 15])
print('-fillpage','-dpdf','mon_fig_hfi_shk')

