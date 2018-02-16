# Data 

1.	Health Employment

	-File Path: ```data/raw/Employment_health_care_8-15-17.xlsx```
 
	-Description: Health employment by year and state

	-Years: 1990-2015

	-Notes: Data are aggregated from approximately 100 BLS time series of employment data. Aggregated data are listed in the "Master" sheet of the file while state-level monthly series are listed with their FRED series ID in their own sheets. Data was collected by Jan Ketterson at Dartmouth. More detailed notes on this data are presented in ```documentation/Notes on Ketterson data.pdf```. The 2015 employment figures herein seem to slightly differ from figures found on the BLS website. 2016 figures were added by Ben Berger.


2.	Health Expenditures
	
	-File Path: ```data/raw/provider-state-estimates/PROV_US_AGGREGATE14.CSV```

	-Description: Aggregate health expenditure data by year and state of provider

	-Years: 1980-2014

	-Notes: Nominal expenditure used to compute per capita real expenditure by combining with population and price-level data. Data were released by CMS on 6-14-17. Data are calculated based on location of health provider or establishment in which health goods are purchased. Further documentation included in "data/provider-state-estimates" directory. Can be found online at https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/NationalHealthExpendData/NationalHealthAccountsStateHealthAccountsProvider.html.


3.	Price-level Data

	-File Path: ```data/raw/ERP-2017-table3.xls```

	-Description: GDP chain type price index. Table B-3 from the 2017 Economic Report of the President. 

	-Years: 1965-2016

	-Notes: Used to adjust health spending figures for inflation. A leaner version of this table is found at ```data/raw/gdp_deflator.xlsx```.


4.	Population

	-File Path: ```data/raw/resident-state-estimates/US_POPULATION14.CSV```

	-Description: US population by state and year

	-Years: 1991-2014

	-Notes: Used to construct average population by state in recent period to weight regression estimates. CMS obtained these population figures from US Census Bureau in July 2017. 

5. 	Employment 
	
	-File Path: ```employment_bls.xlsx```

	-Description: Total US employment by month

	-Years: 1994-2016

	-Notes: BLS data series. Number of private employees in thousands. Seasonally adjusted.

6. 	Processed data panel
	
	-File Path: ```data/raw/resident-state-estimates/US_POPULATION14.CSV```

	-Description: Stata output; US population by state and year

	-Years: 1980-2016

	-Description: State-year-level estimates of

	* Inflation-adjusted health expenditure
	* Healthcare employment
	* Population














