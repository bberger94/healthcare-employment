---
title: 'Data Dictionary'
subtitle: 'Health care spending and employment'
author: 'Ben Berger'
date: \today
---

1.	__Health Employment__

	* Description: Annual health employment by state (thousands of employees)
	* Years: 1990-2016
	* Website: ```fred.stlouisfed.org```
	* Notes: Data are aggregated from 81 BLS time series of non-seasonally adjusted health care employment data downloaded from FRED. Health care employment is calculated as the difference of _Health care and social assistance_ and _Social assistance_ employment for states where both series are available. A standalone series for health care employment (excluding social services) is available only for Alaska. All figures are in thousands of employees. Data was originally collected by Jan Ketterson at Dartmouth and has since been updated by Ben Berger. More detailed notes on this data are presented in ```documentation/Notes on Ketterson data.pdf```.   
	Source code to download the series from the FRED website is located at ```source/import_fred_data/import_data.R```.
	* Relevant files:
		-	```fred_series_ids.csv``` BLS Series IDs and series names.
		-	```health_employment_monthly.csv``` Monthly non-seasonally-adjusted series with derived health sector employment.
		-	```health_employment_annual.csv``` Annual averages of derived health sector employment by state.


2.	__Health Expenditure__
	
	* Description: Annual health expenditure by state of provider (millions of USD)
	* Years: 1980-2014
	* Website: ```cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/NationalHealthExpendData/NationalHealthAccountsStateHealthAccountsProvider.html```
	* Notes: Nominal expenditure used to compute per capita real expenditure by combining with population and price-level data. Data were released by CMS on June 14, 2017. Data are calculated based on location of health provider or establishment in which health goods are purchased. Further documentation included in ```health_spending/provider-state-estimates```.
	* Relevant files: 
		- ```PROV_US_AGGREGATE14.CSV``` Annual health expenditure for each state of provider and type of care-providing establishment or retail medical product. Expenditure for each state is totalled over type to produce total spending estimates.

3.	__Price-level__

	* Description: GDP chain type price index. Table B-3 from the 2017 Economic Report of the President. 
	* Years: 1965-2016
	* Website: ```gpo.gov/fdsys/granule/ERP-2017/ERP-2017-table3```
	* Notes: Used to adjust health spending figures for inflation.
	* Relevant files: 
		- ```ERP-2017-table3.xls``` Table B-3 from the 2017 ERP. Column C -- GDP chain-type price index -- is used to calculate real spending from the nominal figures.
		- ```gdp_deflator.xlsx``` A leaner version of the above table with no formatting and only the GDP deflator column.


4.	__Population__

	* Description: Annual US population by state (thousands of persons)
	* Years: 1991-2014 
	* Website: ```cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/NationalHealthExpendData/NationalHealthAccountsStateHealthAccountsResidence.html```
	* Notes: Used to construct per capita spending and employment. CMS obtained these population figures from the US Census Bureau in July 2017. 
	* Relevant files: 
		- ```US_POPULATION14.CSV``` 


5. __Employment__

	* Description: Monthly US average employment (thousands of employees)
	* Years: 1994-2016
	* Website: ```data.bls.gov/timeseries/CES0500000001```
	* Notes: BLS data series CES0500000001. Number of private employees in thousands. Seasonally adjusted. Used to construct annual average employment (all sectors).
	*  Relevant files:
		- ```employment_bls.xlsx```


6.	__Processed data panel__
	
	* Description: Derived annual state-level estimates of
		- Inflation-adjusted health expenditure
		- Healthcare employment
		- Population
	* Years: 1980-2016
	* Relevant files:
		- ```health_panel_data.dta```






