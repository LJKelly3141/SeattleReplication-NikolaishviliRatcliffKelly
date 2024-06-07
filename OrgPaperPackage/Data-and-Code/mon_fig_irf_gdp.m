load mon_baseline

vnames = {'\fontsize{11}\rm EONIA'    '\fontsize{11}\rm GDP'        '\fontsize{11}\rm Consumer prices' '\fontsize{11}\rm Corp. bond spread' '\fontsize{11}\rm M1'         '\fontsize{11}\rm EUR/USD'    ;
          '\fontsize{9}\rm (percent)' '\fontsize{9}\rm (100 x log)' '\fontsize{9}\rm (100 x log)'      '\fontsize{9}\rm (percent)'          '\fontsize{9}\rm (100 x log)' '\fontsize{9}\rm (100 x log)' }';

gdpIRFcredset = prctile(gdpIRF,[16 50 84],1)/median(gdpIRF(:,1,1))*0.25;
baseIRFcredset = prctile(baseIRF,[16 50 84],1)/median(baseIRF(:,1,1))*0.25;

fig = figure;
i=0;
for j = 1:n
    g(j) = subplot(2,3,j);
    hold on

    d_gdp = (gdpIRFcredset(1,1:H,j))';  
    d_base = (baseIRFcredset(1,1:H,j))';  
    m_gdp  = (gdpIRFcredset(2,1:H,j))';  
    m_base  = (baseIRFcredset(2,1:H,j))';  
    u_gdp = (gdpIRFcredset(3,1:H,j))';  
    u_base = (baseIRFcredset(3,1:H,j))';  

    if j~=2
        f_base = fill([1:H fliplr(1:H)],[u_base' fliplr(d_base')],'b','EdgeColor',[0 0 1]);
        f_base.FaceAlpha = 0.25;
        f_base.EdgeAlpha = 0.25;
        plot([1:H],(m_base),'Color',[0 0 1 0.25],'LineStyle','-','LineWidth',0.75,'HandleVisibility','off');
    end
    f_gdp = fill([1:H fliplr(1:H)],[u_gdp' fliplr(d_gdp')],[1 0.5 0],'EdgeColor',[1 0.5 0]);
    f_gdp.FaceAlpha = 0.25;
    plot([1:H],(m_gdp),'Color',[1 0.5 0],'LineStyle','-','LineWidth',0.75,'HandleVisibility','off');

    plot([0:H],zeros(H+1,1),'Color',[0 0 0],'LineStyle','--','LineWidth',0.5,'HandleVisibility','off');

    xl = [1 H];
    xlim([xl(1) xl(2)]);
    set(gca,'xtick',[xl(1) xl(2)/3 xl(2)/3*2 xl(2)])
    ax = gca;
    ax.YRuler.Exponent = 0;
    title(vnames(j,:));
    if j > n/2
        xlabel('\fontsize{9}\rm Months');
    end
end
set(gcf,'papersize',[15 15])
print('-fillpage','-dpdf','mon_fig_irf_gdp')