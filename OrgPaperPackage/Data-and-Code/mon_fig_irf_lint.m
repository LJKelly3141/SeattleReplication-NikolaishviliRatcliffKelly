load mon_lint

vname = {'\fontsize{11}\rm German bond yield';
         '\fontsize{9}\rm (percent)'}';

hfilintIRFcredset = prctile(hfilintIRF,[16 50 84],1)/median(hfilintIRF(:,1,1))*0.25;
lintIRFcredset = prctile(lintIRF,[16 50 84],1)/median(lintIRF(:,1,1))*0.25;

fig = figure;
i=0;
hold on

d_hfilint = (hfilintIRFcredset(1,1:H,7))';  
d_lint = (lintIRFcredset(1,1:H,7))';  
m_hfilint  = (hfilintIRFcredset(2,1:H,7))';  
m_lint  = (lintIRFcredset(2,1:H,7))';  
u_hfilint = (hfilintIRFcredset(3,1:H,7))';  
u_lint = (lintIRFcredset(3,1:H,7))';  

f_lint = fill([1:H fliplr(1:H)],[u_lint' fliplr(d_lint')],'b','EdgeColor','b');
f_lint.FaceAlpha = 0.25;
plot([1:H],(m_lint),'Color',[0 0 1],'LineStyle','-','LineWidth',0.75,'HandleVisibility','off');
f_hfilint = fill([1:H fliplr(1:H)],[u_hfilint' fliplr(d_hfilint')],[1 0.5 0],'EdgeColor',[1 0.5 0]);
f_hfilint.FaceAlpha = 0.25;
plot([1:H],(m_hfilint),'Color',[1 0.5 0],'LineStyle','-','LineWidth',0.75,'HandleVisibility','off');

plot([0:H],zeros(H+1,1),'Color',[0 0 0],'LineStyle','--','LineWidth',0.5,'HandleVisibility','off');

xl = [1 H];
xlim([xl(1) xl(2)]);
set(gca,'xtick',[xl(1) xl(2)/3 xl(2)/3*2 xl(2)])
ax = gca;
ax.YRuler.Exponent = 0;
title(vname);
xlabel('\fontsize{9}\rm Months');
    
set(gcf,'papersize',[5 7.5])
print('-fillpage','-dpdf','mon_fig_irf_lint')
