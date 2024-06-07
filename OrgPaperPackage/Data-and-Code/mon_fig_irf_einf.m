load mon_einf

vname = {'\fontsize{11}\rm Expected inflation';
         '\fontsize{9}\rm (percent)'}';

hfieinfIRFcredset = prctile(hfieinfIRF,[16 50 84],1)/median(hfieinfIRF(:,1,1))*0.25;
einfIRFcredset = prctile(einfIRF,[16 50 84],1)/median(einfIRF(:,1,1))*0.25;

fig = figure;
i=0;
hold on

d_hfieinf = (hfieinfIRFcredset(1,1:H,7))';  
d_einf = (einfIRFcredset(1,1:H,7))';  
m_hfieinf  = (hfieinfIRFcredset(2,1:H,7))';  
m_einf  = (einfIRFcredset(2,1:H,7))';  
u_hfieinf = (hfieinfIRFcredset(3,1:H,7))';  
u_einf = (einfIRFcredset(3,1:H,7))';  

f_einf = fill([1:H fliplr(1:H)],[u_einf' fliplr(d_einf')],'b','EdgeColor','b');
f_einf.FaceAlpha = 0.25;
plot([1:H],(m_einf),'Color',[0 0 1],'LineStyle','-','LineWidth',0.75,'HandleVisibility','off');
f_hfieinf = fill([1:H fliplr(1:H)],[u_hfieinf' fliplr(d_hfieinf')],[1 0.5 0],'EdgeColor',[1 0.5 0]);
f_hfieinf.FaceAlpha = 0.25;
plot([1:H],(m_hfieinf),'Color',[1 0.5 0],'LineStyle','-','LineWidth',0.75,'HandleVisibility','off');

plot([0:H],zeros(H+1,1),'Color',[0 0 0],'LineStyle','--','LineWidth',0.5,'HandleVisibility','off');

xl = [1 H];
xlim([xl(1) xl(2)]);
set(gca,'xtick',[xl(1) xl(2)/3 xl(2)/3*2 xl(2)])
ax = gca;
ax.YRuler.Exponent = 0;
title(vname);
xlabel('\fontsize{9}\rm Months');
 
set(gcf,'papersize',[5 7.5])
print('-fillpage','-dpdf','mon_fig_irf_einf')
