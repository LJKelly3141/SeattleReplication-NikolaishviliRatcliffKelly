load mon_m3

vname = {'\fontsize{11}\rm M3';
         '\fontsize{9}\rm (100 x log)'}';

hfim3IRFcredset = prctile(hfim3IRF,[16 50 84],1)/median(hfim3IRF(:,1,1))*0.25;
m3IRFcredset = prctile(m3IRF,[16 50 84],1)/median(m3IRF(:,1,1))*0.25;

fig = figure;
i=0;
hold on

d_hfim3 = (hfim3IRFcredset(1,1:H,7))';  
d_m3 = (m3IRFcredset(1,1:H,7))';  
m_hfim3  = (hfim3IRFcredset(2,1:H,7))';  
m_m3  = (m3IRFcredset(2,1:H,7))';  
u_hfim3 = (hfim3IRFcredset(3,1:H,7))';  
u_m3 = (m3IRFcredset(3,1:H,7))';  

f_m3 = fill([1:H fliplr(1:H)],[u_m3' fliplr(d_m3')],'b','EdgeColor','b');
f_m3.FaceAlpha = 0.25;
plot([1:H],(m_m3),'Color',[0 0 1],'LineStyle','-','LineWidth',0.75,'HandleVisibility','off');
f_hfim3 = fill([1:H fliplr(1:H)],[u_hfim3' fliplr(d_hfim3')],[1 0.5 0],'EdgeColor',[1 0.5 0]);
f_hfim3.FaceAlpha = 0.25;
plot([1:H],(m_hfim3),'Color',[1 0.5 0],'LineStyle','-','LineWidth',0.75,'HandleVisibility','off');

plot([0:H],zeros(H+1,1),'Color',[0 0 0],'LineStyle','--','LineWidth',0.5,'HandleVisibility','off');

xl = [1 H];
xlim([xl(1) xl(2)]);
set(gca,'xtick',[xl(1) xl(2)/3 xl(2)/3*2 xl(2)])
ax = gca;
ax.YRuler.Exponent = 0;
title(vname);
xlabel('\fontsize{9}\rm Months');
    
set(gcf,'papersize',[5 7.5])
print('-fillpage','-dpdf','mon_fig_irf_m3')
