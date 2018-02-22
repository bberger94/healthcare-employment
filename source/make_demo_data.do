* Save data for JAMA demo

* Load data
set more off
clear
use data/processed/health_panel_data.dta 

* Drop DC
drop if state == "DISTRICT OF COLUMBIA"

* Keep only 2014
keep if year == 2014

* Reorder variables
order year state state_abbrev

* Write to file
save "demo/health_data_2014.dta"
