medFEVD1 = squeeze(prctile(baseFEVD(:,1,1,:),50))';
lowFEVD1 = squeeze(prctile(baseFEVD(:,1,1,:),16))';
higFEVD1 = squeeze(prctile(baseFEVD(:,1,1,:),84))';

medFEVD60= squeeze(prctile(baseFEVD(:,60,1,:),50))';
lowFEVD60= squeeze(prctile(baseFEVD(:,60,1,:),16))';
higFEVD60= squeeze(prctile(baseFEVD(:,60,1,:),84))';

mon_fevd = [medFEVD1;lowFEVD1;higFEVD1;medFEVD60;lowFEVD60;higFEVD60]

