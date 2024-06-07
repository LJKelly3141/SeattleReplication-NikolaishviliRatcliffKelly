This file contains Matlab code for replicating the results of Badinger, Schiman (2022): "Measuring Monetary Policy in the Euro Area Using SVARs with Residual Restrictions".

The results in the paper were generated using Matlab R2017b, operated on Microsoft Windows 10 Enterprise, version 1809, and double-checked using Matlab 2021b. No toolboxes are required. The appearance of the figures may differ marginally depending on the Matlab version used.

One only needs to run mon_MAIN.m, all other scripts are called by it and all figures of the paper are reproduced. Specifically, the following output of the paper is reproduced:

- Figure 1: mon_fig_hfi.pdf,
- Figure 2: mon_fig_irf_base.pdf,
- Figure 3: mon_fig_irf_hfi.pdf,
- Figure 4: mon_fig_irf_einf.pdf, mon_fig_irf_lint.pdf, mon_fig_irf_m3.pdf,
- Figure 5: mon_fig_bp.pdf,
- Figure 6: mon_fig_hfi_shk.pdf,
- Figure A1: mon_fig_eonia.pdf,
- Figure A2: mon_fig_irf_fur14mr.pdf,
- Figure A3: mon_fig_irf_short.pdf,
- Figure A4: mon_fig_irf_r14.pdf,
- Figure A5: mon_fig_irf_r4m.pdf,
- Figure A6: mon_fig_irf_conj.pdf,
- Figure A7: mon_fig_irf_gdp.pdf,
- Figure A8: mon_fig_irf_core.pdf

The results given in Table 2 (FEVD) are reproduced by running mon_baseline.m separately.

The expected computation time is approximately 14 hours. The random number generator is rng("shuffle").

All data used in the paper is publicly available and was accessed on March 1, 2020. Current data versions may deviate slightly from the version used due to data revisions.

- High-frequency data: https://www.ecb.europa.eu/pub/pdf/annex/Dataset_EA-MPD.xlsx, see also 'mon_fig_hfi.xlsx'
- EONIA: Euro Interbank Offered Rate, Percent, Not seasonally adjusted, https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=198.EON.D.EONIA_TO.RATE
- IP: Production in industry including construction (NACE B-F), euro area (from 2015), 2015=100, Seasonally and calendar adjusted,  https://ec.europa.eu/eurostat/databrowser/view/STS_INPR_M__custom_2573017/default/table?lang=en
- HCPI: Harmonized consumer prices index, all items, euro area (changing composition), 2015=100, Working day and seasonally adjusted, https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=122.ICP.M.U2.Y.000000.3.INX
- CBS: ICE BofA euro high yield index option-adjusted spread, Percent, Not seasonally adjusted, https://fred.stlouisfed.org/series/BAMLHE00EHYIOAS
- M1: Monetary aggregate M1 vis-a-vis euro area non-MFI excluding central government, outstanding amounts at the end of the period, billions of euro, Working day and seasonally adjusted,
https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=117.BSI.M.U2.Y.V.M10.X.1.U2.2300.Z01.E
Note that this series exhibits a jump in June 2005, which is related to the fact that Spanish non-MFI savings accounts were re-classified and included in M1 from then on. We have eliminated this break by adding Spanish non-MFI savings accounts to M1 also prior to June 2005. Spanish non-MFI savings accounts can be accessed via https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=117.BSI.M.ES.N.A.L23.D.1.U2.2200.Z01.E
- USD/EUR: Inverse of euro/US dollar exchange rate, Not seasonally adjusted,
https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=120.EXR.M.USD.EUR.SP00.A
- EINF: ECB Survey of professional forecasters, Euro area HCPI, average of forecasts, target period ends 12 months after survey cycle begins, point forecast, Percent, https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=138.SPF.M.U2.HICP.POINT.P12M.Q.AVG
For more than 2 decimals see Macrobond, ecb_01001604
- 10Y: Long-term interest rate for convergence purposes, Germany, 10 years maturity, new business coverage, denominated in euro, Percent, https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=229.IRS.M.DE.L.L40.CI.0000.EUR.N.Z
- M3: Monetary aggregate M3 vis-a-vis euro area non-MFI excluding central government, outstanding amounts at the end of the period, billions of euro, Working day and seasonally adjusted, https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=117.BSI.M.U2.Y.V.M30.X.1.U2.2300.Z01.E
- GDP: Gross domestic product, euro area (from 2015), reference year 2010, Chained volumes, billions of euro, Calendar and seasonally adjusted, https://ec.europa.eu/eurostat/databrowser/view/NAMQ_10_GDP__custom_3171593/default/table?lang=en
- CHCPI: Harmonized consumer prices index, all items excluding energy and unprocessed food, euro area (changing composition), 2015=100, Workig day and seasonally adjusted, https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=122.ICP.M.U2.Y.XEFUN0.3.INX

The file 'Eonia.xlsx' contains daily data on Eonia and is called by the m-file mon_fig_eonia.