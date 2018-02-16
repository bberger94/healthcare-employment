*--------------------------------------------------
* 02_regressions.do
* for estimating regressions of spending growth on lagged employment growth
* Last updated 08-14-17
* Author: Ben Berger
* Notes: 
* 1. Execute script from healthcare-employment directory
*--------------------------------------------------

clear all
set more off

local data_dir "data"
local healthEmploy_data "`data_dir'/raw/employment/employment_annual_data_2018-02-16.csv"
local employ_data "`data_dir'/raw/employment_bls.xlsx"
local provider_spend_data "`data_dir'/raw/provider-state-estimates/PROV_US_AGGREGATE14.CSV"
local gdp_deflator "`data_dir'/raw/gdp_deflator.xlsx"
local pop_data "`data_dir'/raw/resident-state-estimates/US_POPULATION14.CSV" 

!mkdir "`data_dir'/processed"

********************************************************************************
********************************************************************************
** Load Population data
********************************************************************************
import delimited "`pop_data'", clear 
keep if group == "State"
keep state_name y*

rename state_name state 
rename y* population*

reshape long population , i(state) j(year)
replace population = population * 1000

tempfile population_long
save "`population_long'"


********************************************************************************
********************************************************************************
**Load Healthcare employment data
********************************************************************************
import delimited "`healthEmploy_data'", ///
	clear ///
	case(preserve)

rename * healthEmploy_*
rename healthEmploy_year year

reshape long  healthEmploy_ , i(year) j(state) string
rename healthEmploy_ healthEmploy
replace healthEmploy = 1000 * healthEmploy
label variable healthEmploy "Healthcare employment (Number of employees)"	

moss state, match("([A-Z][^A-Z]*)") regex
replace state = _match1 + " " + _match2
replace state = trim(state)

keep year state healthEmploy
sort state year

tempfile healthEmploy_long
save "`healthEmploy_long'"


********************************************************************************
********************************************************************************
**Load Healthcare spend data (provider)
********************************************************************************
import delimited "`provider_spend_data'", clear

keep if group == "State"
keep item state_name y*

collapse (sum) y*, by(state_name)
rename state_name state
rename y* healthSpend*

reshape long healthSpend , i(state) j(year) 
replace healthSpend = healthSpend * 1000000

tempfile healthSpend_long
save "`healthSpend_long'", replace

*Adjust for inflation (chained 2014 dollars)
import excel using `gdp_deflator', clear ///
	firstrow ///
	sheet("Sheet1")

summarize gdp_deflator if year == 2014
local base_year_deflator `r(min)'
replace gdp_deflator = gdp_deflator / `base_year_deflator'

merge 1:m year using `healthSpend_long', ///
	keep(3) nogenerate

replace healthSpend = healthSpend / gdp_deflator
label variable healthSpend "Healthcare expenditure (Chained 2014 dollars)"	


keep year state healthSpend
sort state year

tempfile healthSpend_long
save "`healthSpend_long'"


********************************************************************************
********************************************************************************
**Merge all data together
********************************************************************************
merge 1:1 state year using "`population_long'"
drop _merge
merge 1:1 state year using "`healthEmploy_long'"
drop _merge
order state year healthSpend healthEmploy population
sort state year

* Write the data to file
save "data/processed/health_panel_data.dta", replace

*************************************************************************
*************************************************************************
*************************************************************************
*************************************************************************
/*Reshape so that each row corresponds to a state
and each column corresponds to a variable x year pair  */
reshape wide health* population*, i(state) j(year)

* log using "reports/regressions_08-04-17.log", replace

*Generate average population over 2010-2014
order state health* population*
egen avg_population_10_14 = rowmean(population2010-population2014)

*Generate spending growth (healthcare spending in chained 2014 dollars by state)
gen spendGrow_10_14 = log(healthSpend2014) - log(healthSpend2010)
gen spendGrow_04_09 = log(healthSpend2009) - log(healthSpend2004)

*Generate employment growth (number of healthcare employees by state)
gen employGrow_10_14 = log(healthEmploy2014) - log(healthEmploy2010)
gen employGrow_04_09 = log(healthEmploy2009) - log(healthEmploy2004)

*Estimate models
reg spendGrow_10_14 	employGrow_10_14  ///
			[aw=avg_population_10_14], robust 

reg spendGrow_10_14 	employGrow_10_14 employGrow_04_09 ///
			[aw=avg_population_10_14], robust

reg spendGrow_10_14 	employGrow_10_14 employGrow_04_09 spendGrow_04_09 ///
			[aw=avg_population_10_14], robust

reg spendGrow_10_14 	employGrow_04_09 spendGrow_04_09 ///
			[aw=avg_population_10_14], robust


*log close
/*
reg spendGrow_10_14 ///
    employGrow_04_09 spendGrow_04_09, robust

reg spendGrow_10_14 ///
    employGrow_10_14 employGrow_04_09 spendGrow_04_09, robust



/*
twoway scatter spendGrow_09_14 employGrow_04_09 || lfit spendGrow_09_14 employGrow_04_09, ///
	title("Growth in healthcare spending and employment for 41 US States", size(medium)) ///
	xtitle("Change in log of healthcare employment 2004-2009", size(small)) ///
	ytitle("Change in log of healthcare spending 2009-2014", size(small)) ///
	xlabel(,labsize(small)) ylabel(,labsize(small) angle(0) ) ///
	legend(off)
	
reg spendGrow_09_14 employGrow_04_09 
//reg spendGrow_09_14 employGrow_04_09 employGrow_09_14





/*
tsset state_id year

**Take first differences
gen d_healthEmploy = healthEmploy - L.healthEmploy
sort state year

