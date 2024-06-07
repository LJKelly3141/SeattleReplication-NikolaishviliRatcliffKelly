equ = 1;

TIME1 = 47-p;  % 2002m11   REST  
TIME2 = 48-p;  % 2002m12   EXP  
TIME3 = 51-p;  % 2003m3    REST  
TIME4 = 54-p;  % 2003m6    EXP  
TIME5 = 118-p; % 2008m10   EXP   
TIME6 = 119-p; % 2008m11   REST  
TIME7 = 120-p; % 2008m12   REST
TIME8 = 121-p; % 2009m1    EXP
TIME9 = 123-p; % 2009m3    REST  
TIME10= 124-p; % 2009m4    REST
TIME11= 154-p; % 2011m10   REST 
TIME12= 155-p; % 2011m11   EXP   
TIME13= 163-p; % 2012m7    EXP
TIME14= 189-p; % 2014m9    EXP
TIME15= 204-p; % 2015m12   REST

fig = figure;
hold on
ylim([-3 3]);
set(gca,'yticklabel',[0])
set(gca,'ytick',[-4 0 4])

A = area([4.5 6.5],[3 3],-3,'Facecolor',[1 0.5 0],'Edgecolor','w'); 
A.FaceAlpha = 0.25;
B = area([10.5 12.5],[3 3],'Facecolor',[1 0.5 0],'Edgecolor','w'); 
B.FaceAlpha = 0.25;
plot([0:16],zeros(17,1),'Color',[0 0 0],'LineWidth',0.5,'LineStyle','-','Color','k');
bplot(baseSHK(:,[TIME1,TIME2,TIME3,TIME4,TIME5,TIME6,TIME7,TIME8,TIME9,TIME10,TIME11,TIME12,TIME13,TIME14,TIME15],equ),'nomean','nooutliers','boxedge',25,'whiskeredge',16,'linewidth',0.75);

set(gca,'xtick',[1:15])
set(gca,'xticklabel',[" Nov. 2002 (+) " " Dec. 2002 (-) " " Mar. 2003 (+) " " Jun. 2003 (-) " " Oct. 2008 (-) " " Nov. 2008 (+) " " Dec. 2008 (+) " " Jan. 2009 (-) " " Mar. 2009 (+) " " Apr. 2009 (+) " " Oct. 2011 (+) " " Nov. 2011 (-) " " Jul. 2012 (-) " " Sep. 2014 (-) " " Dec. 2015 (+) "])
xtickangle(90)
xlim([0 16])
ax = gca;
xticklabels(ax, strrep(xticklabels(ax),'-',char(8211)));

set(gcf,'papersize',[15 15])
print('-fillpage','-dpdf','mon_fig_bp')
