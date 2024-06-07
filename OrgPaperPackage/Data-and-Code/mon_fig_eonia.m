[eonia] = xlsread('Eonia.xlsx');
eoniadata = eonia(:,2:4);
dn = eonia(:,1);

fig = figure;

subplot(2,2,1)
hold on
plot(eoniadata(2514:2536),'k','Linewidth',0.5,'Linestyle','-','Marker','.');
plot(eoniadata(2514:2536,2),'color',[1 0.5 0],'Linewidth',0.5,'Linestyle','-','Marker','.');
plot(eoniadata(2514:2536,3),'b','Linewidth',0.75,'Linestyle','-');
xlim([1 23]);
ylim([3 5]);
set(gca,'xtick',7)
set(gca,'xticklabel',["Oct. 9"])
line([7 7],ylim,'Color','k','LineWidth',0.5,'LineStyle',':');
title('\fontsize{11}\rm October 2008');

subplot(2,2,2)
hold on
plot(eoniadata(2537:2556),'k','Linewidth',0.5,'Linestyle','-','Marker','.');
plot(eoniadata(2537:2556,2),'color',[1 0.5 0],'Linewidth',0.5,'Linestyle','-','Marker','.');
plot(eoniadata(2537:2556,3),'b','Linewidth',0.75,'Linestyle','-.');
xlim([1 20]);
ylim([2.5 4]);
set(gca,'xtick',8)
set(gca,'xticklabel',["Nov. 12"])
line([8 8],ylim,'Color','k','LineWidth',0.5,'LineStyle',':');
title('\fontsize{11}\rm November 2008');

subplot(2,2,3)
hold on
plot(eoniadata(3291:3311),'k','Linewidth',0.5,'Linestyle','-','Marker','.');
plot(eoniadata(3291:3311,2),'color',[1 0.5 0],'Linewidth',0.5,'Linestyle','-','Marker','.');
plot(eoniadata(3291:3311,3),'b','Linewidth',0.75,'Linestyle','-.');
xlim([1 21]);
ylim([0.8 1.4]);
set(gca,'xtick',8)
set(gca,'xticklabel',["Oct. 12"])
line([8 8],ylim,'Color','k','LineWidth',0.5,'LineStyle',':');
title('\fontsize{11}\rm October 2011');

subplot(2,2,4)
hold on
plot(eoniadata(3312:3333),'k','Linewidth',0.5,'Linestyle','-','Marker','.');
plot(eoniadata(3312:3333,3),'b','Linewidth',0.75,'Linestyle','-.');
xlim([1 22]);
ylim([0.6 1.4]);
set(gca,'xtick',7)
set(gca,'xticklabel',["Nov. 9"])
line([7 7],ylim,'Color','k','LineWidth',0.5,'LineStyle',':');
title('\fontsize{11}\rm November 2011');

set(gcf,'papersize',[15 15])
print('-fillpage','-dpdf','mon_fig_eonia')
