*--------------------------------------------------
* 01_figures.do
* for plotting aggregate healthcare spending and employment
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
local spend_data "`data_dir'/raw/provider-state-estimates/PROV_US_AGGREGATE14.CSV"
local gdp_deflator "`data_dir'/raw/gdp_deflator.xlsx"
local pop_data "`data_dir'/raw/resident-state-estimates/US_POPULATION14.CSV" 
local first_year 2000
local last_year 2016


********************************************************************************
********************************************************************************
**Load Healthcare employment data
********************************************************************************
import delimited "`healthEmploy_data'", ///
	clear case(preserve)
	
rename * healthEmploy_*
rename healthEmploy_year year
keep if year >= `first_year'

*Drop states without data for `first_year' or any year after
foreach var of varlist healthEmploy_* {
 quietly count if missing(`var')
 if `r(N)' > 0 drop `var' 
}

egen healthEmploy_total = rowtotal(healthEmploy_*)

keep year healthEmploy_total
tempfile health_employ
save "`health_employ'"

********************************************************************************
********************************************************************************
**Load employment data (all sectors)
********************************************************************************
import excel "`employ_data'", ///
	firstrow ///
	clear

rename * employ_*
rename employ_Year year
keep if year >= `first_year'

*Take the average employment for each year over 12 months
egen employ_total = rowmean(employ_*)

keep year employ_total
tempfile employ
save "`employ'"


********************************************************************************
********************************************************************************
**Load Healthcare expenditures data
********************************************************************************
import delimited "`spend_data'", clear
keep if state_name != ""

rename state_name state
keep state y*
rename y* spend_nom*

collapse (sum) spend_nom* , by(state)

reshape long spend_nom, i(state) j(year)
replace spend_nom = spend_nom * 1000000

keep if year >= `first_year'

tempfile health_spend
save "`health_spend'"

********************************************************************************
********************************************************************************
** Merge population data to create per capita spending
********************************************************************************
import delimited "`pop_data'", clear
keep if group == "State"
keep state_name y*

rename state_name state 
rename y* population*

reshape long population , i(state) j(year)
replace population = population * 1000

merge 1:1 state year using `health_spend', keep(3) nogenerate

tempfile health_spend
save "`health_spend'"

********************************************************************************
**Adjust for inflation
*Load GDP deflator data
import excel using `gdp_deflator', clear ///
	firstrow ///
	sheet("Sheet1")

summarize gdp_deflator if year == 2014
local base_year_deflator `r(min)'
replace gdp_deflator = gdp_deflator / `base_year_deflator'

merge 1:m year using `health_spend', ///
	keep(3) nogenerate

gen double spend_real = spend_nom / gdp_deflator

collapse (sum) population spend_real, by(year)

gen spend_real_pc = spend_real / population

keep year spend_real_pc
tempfile health_spend
save `health_spend', replace


*******************************************************************************
********************************************************************************
*Merge together data for plotting
********************************************************************************
use "`health_employ'", clear

merge m:1 year using "`health_spend'", nogenerate
merge m:1 year using "`employ'", nogenerate
sort year

drop if year > `last_year'

/*    Scale each variable so that their
      value in 2000 (or whatever is the first year in data) = 100  */
foreach var of varlist employ_total healthEmploy_total spend_real_pc {
	summarize `var' if year == `first_year'
	replace `var' = `var'/`r(min)' * 100
}

********************************************************************************
********************************************************************************
**Plot
********************************************************************************
twoway 	///
	line healthEmploy_total year || ///
	line employ_total year || ///
	line spend_real_pc year , ///
	title("National Health Employment and Expenditure") ///
	xtitle("Year") ///
	yaxis(1 2) ///
	ytitle("Health Expenditure, Year 2000 = 100", axis(1)) ///
	ytitle("Number Employed, Year 2000 = 100", axis(2)) ///
	ylabel("", axis(1)) ///
	ylabel(, axis(2) angle(0)) ///
	legend(cols(1)	label(1 "Healthcare Employment") ///
			label(2 "Total Employment") ///
			label(3 "Per Capita Real Health Expenditure") ///
			) 

graph export "figures/figure-01.eps", replace

