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
local healthEmploy_data "`data_dir'/Employment health care jan 6_16_16.xlsx"
local employ_data "`data_dir'/employment_bls.xlsx"
local spend_data "`data_dir'/resident-state-estimates/US_PER_CAPITA14.CSV"
local gdp_deflator "`data_dir'/gdp_deflator.xlsx"
local first_year 2000

!mkdir "`data_dir'/temp"
!mkdir "`data_dir'/processed"

********************************************************************************
********************************************************************************
**Load Healthcare employment data
********************************************************************************
import excel "`healthEmploy_data'", ///
	sheet("Master") ///
	firstrow ///
	clear
	
rename * healthEmploy_*
rename healthEmploy_A year
keep if year >= `first_year'

*Drop states without data for `first_year' or any year after
foreach var of varlist healthEmploy_* {
 quietly count if missing(`var')
 if `r(N)' > 0 drop `var' 
}

egen healthEmploy_total = rowtotal(healthEmploy_*)

keep year healthEmploy_total
save "`data_dir'/processed/health_employ.dta", replace

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
save "`data_dir'/processed/employ.dta", replace

********************************************************************************
********************************************************************************
**Load Healthcare expenditures data
********************************************************************************
import delimited "`spend_data'", clear
keep if region_name == "United States"

keep y*
rename y* spend_nom*
collapse (sum) *
gen id = 1

reshape long spend_nom, i(id) j(year)
drop id
keep if year >= `first_year'

save "`data_dir'/temp/spend_temp.dta", replace

********************************************************************************
**Adjust for inflation
*Load GDP deflator data
import excel using `gdp_deflator', clear ///
	firstrow ///
	sheet("Sheet1")

summarize gdp_deflator if year == 2014
local base_year_deflator `r(min)'
replace gdp_deflator = gdp_deflator / `base_year_deflator'

merge m:1 year using `data_dir'/temp/spend_temp, ///
	keep(3) nogenerate

gen spend_real = spend_nom / gdp_deflator

keep year spend_real
save "`data_dir'/processed/spend.dta", replace


********************************************************************************
********************************************************************************
*Merge together data for plotting
********************************************************************************
use "`data_dir'/processed/health_employ.dta"

merge m:1 year using "`data_dir'/processed/spend.dta", nogenerate
merge m:1 year using "`data_dir'/processed/employ.dta", nogenerate
sort year

/*    Scale each variable so that their
      value in 2000 (or whatever is the first year in data) = 100  */
      
foreach var of varlist employ_total healthEmploy_total spend_real {
	summarize `var' if year == `first_year'
	replace `var' = `var'/`r(min)' * 100
}

********************************************************************************
********************************************************************************
**Plot
********************************************************************************
twoway 	line healthEmploy_total year || ///
	line employ_total year || ///
	line spend_real year , ///
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



