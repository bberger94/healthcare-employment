capture log close
log using "C:\Users\Jon Skinner\Dropbox\JSS\Chandra projects\Employment and Spending\CS_figure.log", replace

* Making Figure for employment and spending
* jss 01/20/18
set more off
clear
cd "C:\Users\Jon Skinner\Dropbox\JSS\Chandra projects\Employment and Spending" 
use health_data.dta 

* Drop DC
drop if state == "District of Columbia"
* Create per-capita measures

gen emp_pc = healthEmploy/population
gen spend_pc = healthSpend/population

label var emp_pc "Health Sector Jobs per capita"
label var spend_pc "Health Spending per capita" 

pwcorr emp_pc spend_pc if year == 2014, sig
pwcorr emp_pc spend_pc [aw=pop] if year == 2014, sig

twoway scatter spend_pc emp_pc if year == 2014, mlabel(state_2digit)

*Now to look at the relevant measures by year:
tab year [aw=pop], sum(emp_pc)
tab year [aw=pop], sum(spend_pc)

* Time-series analysis
sort state
encode state, gen(state_n)
sum state_n
tsset state_n year

* Spending per job in 2014

keep if year == 2014

drop if emp_pc == .
drop if spend_pc == .

egen tot_emp = sum(healthEmploy)
egen tot_spend = sum(healthSpend)
disp tot_spend/tot_emp



log close

