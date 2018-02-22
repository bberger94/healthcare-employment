* Plot percapita employment and spending by state in 2014
* Put this file in the same directory as health_data_2014.dta

* Load data
set more off
clear
use health_data_2014.dta 

* Create per-capita measures
gen emp_pc = healthEmploy/population
gen spend_pc = healthSpend/population

label var emp_pc "Health Sector Jobs per capita"
label var spend_pc "Health Spending per capita" 

* Calculate correlation coefficient
pwcorr emp_pc spend_pc, sig
pwcorr emp_pc spend_pc [aw=pop], sig

* Make plot
twoway scatter spend_pc emp_pc, mlabel(state_abbrev)
graph save "scatterplot.eps", replace
