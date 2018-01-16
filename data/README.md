# Data sources 

1.	-File Path: "data/raw/Employment health care jan 6_16_16.xlsx"
 
	-Description: Health employment by year and state

	-Years: 1990-2015

	-Notes: Data are aggregated from approximately 100 BLS time series of employment data. Aggregated data are listed in the "Master" sheet of the file while state-level monthly series are listed with their FRED series ID in their own sheets. Data was collected by Jan Ketterson at Dartmouth. More detailed notes on this data are presented in "documentation/Notes on Ketterson data.pdf". The 2015 employment figures herein seem to slightly differ from figures found on the BLS website. We should be able to obtain data from this source through 2016 with some effort.


2.	-File Path: "data/raw/resident-state-estimates/US_PER_CAPITA14.CSV"

	-Description: Per capita health expenditure by year and state of residence

	-Years: 1991-2014

	-Notes: These figures are used to produce Figure 1. Data were released by CMS on 6-14-17. Documentation is included in "data/resident-state-estimates" directory. Spending figures are listed for 10 different categories of health spending. We total these figures by state and year to obtain aggregate per capita state x year health spending figures. Data can be found online at https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/NationalHealthExpendData/NationalHealthAccountsStateHealthAccountsResidence.html.


3.	-File Path: "data/raw/provider-state-estimates/PROV_US_AGGREGATE14.CSV"

	-Description: Aggregate health expenditure data by year and state of provider

	-Years: 1980-2014

	-Notes: These data are used as contemporaneous and lagged health expenditures in regression models. Data were released by CMS on 6-14-17. Data are calculated based on location of health provider or establishment in which health goods are purchased. Further documentation included in "data/provider-state-estimates" directory. Data can be found online at https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/NationalHealthExpendData/NationalHealthAccountsStateHealthAccountsProvider.html.


4.	-File Path: "data/raw/ERP-2017-table3.xls"

	-Description: GDP chain type price index. Table B-3 from the 2017 Economic Report of the President. 

	-Years: 1965-2016

	-Notes: These data are used to adjust spending figures for inflation. A leaner version of this table is found at "data/raw/gdp_deflator.xlsx".


5.	-File Path: "data/raw/resident-state-estimates/US_POPULATION14.CSV"

	-Description: US population by state and year

	-Years: 1991-2014

	-Notes: Used to construct average population by state in recent period to weight regression estimates. CMS sourced these population figures from US Census Bureau in July 2017. 


