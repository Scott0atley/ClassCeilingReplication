
cd "/Users/ScottOatley/Documents/UKDA-6614-stata/stata/stata13_se/bhps"

use "/Users/ScottOatley/Documents/UKDA-6614-stata/stata/stata13_se/bhps/ba_indresp"

numlabel _all, add

codebook ba_mrjsoc ba_sex ba_age_dv ba_panssec8_dv ba_fimnlabgrs_dv ba_mrjmngr, compact

summarize ba_age_dv, detail
gen c_age=ba_age_dv - r(min)

gen c_age2=c_age^2

tab ba_panssec8_dv
gen nssecf = ba_panssec8_dv
replace nssecf=. if (nssecf<0)
tab nssecf

tab ba_manssec8_dv
gen nssecm = ba_manssec8_dv
replace nssecm=. if (nssecm<0)
tab nssecm

gen nssecdom=.
replace nssecdom=1 if (nssecf==1 & nssecm>=1)
replace nssecdom=1 if (nssecf>=1 & nssecm==1)
replace nssecdom=2 if (nssecf==2 & nssecm>=2)
replace nssecdom=2 if (nssecf>=2 & nssecm==2)
replace nssecdom=3 if (nssecf==3 & nssecm>=3)
replace nssecdom=3 if (nssecf>=3 & nssecm==3)
replace nssecdom=4 if (nssecf==4 & nssecm>=4)
replace nssecdom=4 if (nssecf>=4 & nssecm==4)
replace nssecdom=5 if (nssecf==5 & nssecm>=5)
replace nssecdom=5 if (nssecf>=5 & nssecm==5)
replace nssecdom=6 if (nssecf==6 & nssecm>=6)
replace nssecdom=6 if (nssecf>=6 & nssecm==6)
replace nssecdom=7 if (nssecf==7 & nssecm>=7)
replace nssecdom=7 if (nssecf>=7 & nssecm==7)
replace nssecdom=8 if (nssecf==8 & nssecm>=8)
replace nssecdom=8 if (nssecf>=8 & nssecm==8)
tab nssecdom

label define nssecdom_lbl 1"Large employers & higher management" 2"Higher professional" 3"Lower management & professional" 4"Intermediate" 5"Small employers & own account" 6" Lower supervisory & technical" 7"Semi-routine" 8"Routine"
label values nssecdom nssecdom_lbl

gen labincome = ba_fimnlabgrs_dv
replace labincome=. if (labincome<10)
gen logincome = log(labincome)

gen soc = ba_mrjsoc
replace soc=. if (soc<0)

gen sex = ba_sex 
label define sex_lbl 1"Male" 2"Female"
label values sex sex_lbl

gen super =.
replace super=1 if (ba_mrjmngr==1)
replace super=1 if (ba_mrjmngr==2)
replace super=0 if (ba_mrjmngr==3)
label define super_lbl 1"Managerial/Supervisory" 0"Non-Managerial/Supervisory"
label value super super_lbl

gen higher =. 
replace higher=1 if (ba_qfedhi>=1 & ba_qfedhi<=5)
replace higher=0 if (ba_qfedhi>=6 & ba_qfedhi<=13)
label define higher_lbl 1"Higher Education Qualification" 0"No Higher Education Qualification"
label values higher higher_lbl

gen region =.
replace region=1 if (ba_region>=1 & ba_region<=2)
replace region=2 if (ba_region>=3 & ba_region<=14)
replace region=3 if (ba_region==15)
replace region=4 if (ba_region==16)
label define region_lbl 1"London" 2"England" 3"Wales" 4"Scotland"
label values region region_lbl

gen c_labhours = ba_jbhrs 
replace c_labhours=. if (c_labhours<1)
*need to centre properly

gen union = ba_orgm2
replace union=. if (union<0)
label define union_lbl 0"Not Mentioned" 1"Member of Trade Union"
label values union union_lbl

gen womeni = ba_orgm14
replace womeni=. if (womeni<0)
label define womeni_lbl 0"Not Mentioned" 1"Member of Women's Institute"
label values womeni womeni_lbl

gen womeng = ba_orgm15
replace womeng=. if (womeng<0)
label define womeng_lbl 0"Not Mentioned" 1"Member of Women's Group"
label values womeng womeng_lbl

gen religion = ba_orgm6
replace religion=. if (religion<0)
label define religion_lbl 0"Not Mentioned" 1"Member of Religious Org"
label values religion religion_lbl

gen sports = ba_orgm13
replace sports=. if (sports<0)
label define sports_lbl 0"Not Mentioned" 1"Member of Sports Group"
label values sports sports_lbl


label variable nssecf "Father's Social Class at Age 14 (NS-SEC)"
label variable nssecm "Mother's Social Class at Age 14 (NS-SEC)"
label variable nssecdom "Dominant Social Class at Age 14 (NS-SEC)"
label variable logincome "Log Total Labour Income"
label variable sex "Sex of Respondent"
label variable soc "SOC code of present Occupation"
label variable c_age "Age of Respondent (Centred)"
label variable c_age2 "Age of Repondent Squared (Centred)"
label variable super "Managerial/Supervisory duties in Most Recent Job"
label variable higher "Higher Education Qualification"
label variable region "Region of Respondent"
label variable c_labhours "Average Weekly Hours Spent Working (Centred)"
label variable union "Union Membership"
label variable womeni "Women's Institute Membership"
label variable womeng "Women's Group Membership"
label variable religion "Religious Membership"
label variable sports "Sports Membership"

codebook logincome nssecdom sex soc c_age c_age2 super higher ba_region c_labhours union womeni womeng religion sports, compact

egen miss1=rmiss(logincome nssecdom sex soc c_age c_age2 super higher ba_region c_labhours union womeni womeng religion sports)
tab miss1
keep if miss1==0

* Linear regression:
regress logincome i.nssecdom sex c_age c_age2 super higher c_labhours union womeni womeng religion sports

est store linear

* Random intercepts regression:
mixed logincome i.nssecdom sex c_age c_age2 super higher c_labhours union womeni womeng religion sports ///
    ||soc:, mle
	
est store interceptsoc
estat icc

gllamm logincome nssecdom sex c_age c_age2 super higher c_labhours union womeni womeng religion sports,  ///
   i(soc) adapt nip(12)
est store l3_bg

est restore interceptsoc
capture drop pred_1
predict pred_1, xb
capture drop res
gen res = logincome - pred_1 /* The residual for each individual */
capture drop l2res
egen l2res = mean(res), by(soc) /* These are the residuals at level 2 */


cd "C:\Users\so22498\Pictures\graphs"

histogram res , normal title("Level 1 residuals")
graph save "level1residuals.gph", replace
graph twoway (scatter res c_labhours) , title("Level 1 residuals, by x-var for labour hours")
graph save "level1residualslabhours.gph", replace
graph combine "level1residuals.gph" "level1residualslabhours.gph", cols(2)

** Looking at level 2 residuals:
histogram l2res, normal title("Level 2 residuals")
graph save "level2residuals.gph", replace
capture drop ebi_p* 
predict ebi_p1, reffects /* 'Empirical Bayes Estimates' of residuals */
list soc ebi_p1 in 1/100
** IE ebi_p1 are at the soc level (level 2)
histogram ebi_p1, normal title("Empirical Bayes residuals at level 2")
graph save "bayeslevel2residuals.gph", replace


capture drop reff_*
est restore l3_bg
gllapred reff_, u /* Generates new variables with the group level residuals and standard errors for them */
summarize reff_*
list soc reff_* in 1/100
* In this framework, the _1's are the soc level
capture drop first
egen first=tag(soc)
gsort +reff_m1 -first
capture drop rank
gen rank=sum(first) /* sum returns the running sum of first in sort order */
capture drop labpos
gen labpos = reff_m1 + 1.96*reff_s1 + 0.4 /* Uses prediction error estimates, ie plus or minus 2 sds */
replace labpos = reff_m1 - 1.96*reff_s1 - 0.4 if (floor(rank/2))*2==rank 
*(labpos determines where the label will go; these lines set it above or below the plot point)
serrbar reff_m1 reff_s1 rank if first==1 , ///
     addplot(scatter labpos rank, mlabel(soc) msymbol(none) mlabpos(0) mlabsize(tiny)  ) ///
     scale(1.96) title("Level 2 residuals in rank order")  ///
    xtitle("Rank") ytitle("Prediction") legend(off) 
graph save "rankorder.gph", replace
graph combine "level2residuals.gph" "bayeslevel2residuals.gph" "rankorder.gph"


**


*Confirms that soc (job) clustering does matter

mixed logincome i.nssecdom sex c_age c_age2 super higher c_labhours union womeni womeng religion sports ///
    ||ba_region:, mle

est store interceptregion
estat icc

est restore interceptregion
capture drop pred_1
predict pred_1, xb
capture drop res
gen res = logincome - pred_1 /* The residual for each individual */
capture drop l2res
egen l2res = mean(res), by(ba_region) /* These are the residuals at level 2 */

* Three Level non-nested cross-classified clustering random intercept model:
mixed logincome i.nssecdom sex c_age c_age2 super higher c_labhours union womeni womeng religion sports ///
 ||_all:R.soc ,cov(identity) ///
 ||ba_region:, mle
xtm3_var

est store intercept3
* i.e. individuals clustered in soc clustered in regions 

* Random slopes regressions:
mixed logincome i.nssecdom sex c_age c_age2 super higher c_labhours union womeni womeng religion sports ///
    ||soc: sex, mle cov(unstructured) 
	
est store slopesex
estat recovariance

mixed logincome i.nssecdom sex c_age c_age2 super higher c_labhours union womeni womeng religion sports ///
    ||soc: nssecdom, mle cov(unstructured)

est store slopenssec
estat recovariance

mixed logincome i.nssecdom sex c_age c_age2 super higher c_labhours union womeni womeng religion sports ///
    ||soc: c_labhours, mle cov(unstructured)

est store slopelabhours
estat recovariance

mixed logincome i.nssecdom sex c_age c_age2 super higher c_labhours union womeni womeng religion sports ///
    ||soc: i.nssecdom, mle cov(identity)

est store slopenssec
estat recovariance

est table interceptsoc interceptregion intercept3 slopesex slopenssec slopelabhours slopenssec, stats(ll bic N) b(%9.4g) star


* graphs
cd "/Users/ScottOatley/Documents/Graphs"

regress logincome i.nssecdom sex c_age c_age2 super higher c_labhours union womeni womeng religion sports

capture drop p_1
gen p_1 = _b[_cons] + _b[c_labhours]*c_labhours  /* Other effects are set to 0 or the contrast category */
graph twoway (scatter logincome c_labhours , mcolor(gs8) msymbol(smcircle) ) ///
    (line p_1 c_labhours if miss1==0, sort lwidth(thick) ) ///
     , xtitle("Labour Hours") ytitle("Labour income") title("Overall regression") 

graph save "bit1.gph", replace



** Lines job by job: 
capture drop num
egen num=count(logincome) , by(soc) /* Tells us how many records per qpsu */
statsby inter=_b[_cons] b1=_b[c_labhours]  /// 
      , by(soc) saving("/Users/ScottOatley/Documents", replace): ///
    regress logincome i.nssecdom sex c_age c_age2 super higher c_labhours union womeni womeng religion sports if num >= 10 & num <= 100000
* (Runs a regression for each job with 10 or more respondents; stores the regression results in ols.dta")
sort soc
merge soc using "/Users/ScottOatley/Documents"
tab _merge
drop _merge
summarize /* The new variables slope and intercept are qpsu-by-qpsu estimates for the larger qpsus */
capture drop p2
gen p2 = inter + b1*c_labhours 
sort soc c_labhours
graph twoway  (scatter logincome c_labhours, mcolor(gs10) msymbol(smcircle) msize(vsmall) )  ///
       (line p2 c_labhours, connect(ascending))  ,  legend (off) ///
      xtitle("Labour Hours") ytitle("Fitted regression lines") title("Job lines (if n >= 10)") 
	  
graph save "bit2.gph", replace


** Show the residuals of the random intercepts lines per soc
mixed logincome i.nssecdom sex c_age c_age2 super higher c_labhours union womeni womeng religion sports ///
      ||soc:, mle
est store m1
estat recovariance
* Get the job level empirical bayes residual: 
capture drop ebi
predict ebi, reffects
version 16: table soc, c(mean ebi mean logincome) 
scatter ebi logincome
* Comment: the mean of lfimnl is the job mean irrespective of other factors; 
*     the ebi is the job residual controlling for other factors
est restore m1
capture drop p3
gen p3 = _b[_cons] + _b[c_labhours]*c_labhours ///
    + ebi  /* Empirical bayes adjusted linear predictor */

capture drop p3l
gen p3l = _b[_cons] + _b[c_labhours]*c_labhours   /* Linear predictor */
   
sort soc c_labhours
graph twoway (scatter logincome c_labhours, mcolor(gs10) msymbol(smcircle) msize(vsmall) ) /// 
    (line p3 c_labhours, connect(ascending)  lwidth(thin) lcolor(gs4) lpattern(solid) ) ///
    (line p3l c_labhours, sort  lwidth(thick) lcolor(orange) lpattern(solid) )  ///
     , xtitle("Labour Hours") ytitle("Labour income") title("Random intercepts") ///
    legend(cols(2) order(2 3) label(2 "qpsu resids") label(3 "Overall")  )  
	  
graph save "bit3.gph", replace

	  

** Show the residuals of the random slopes lines per job

mixed logincome i.nssecdom sex c_age c_age2 super higher c_labhours union womeni womeng religion sports ///
      ||soc: c_labhours , mle cov(unstructured)  
est store m2
estat recovariance

* Get the job level empirical bayes residuals: 
capture drop ebi 
capture drop esi
predict ebs ebi, reffects
version 16: table soc, c(mean ebi mean ebs mean logincome) 
scatter ebi logincome
* Comment: the mean of lfimnl is the job mean irrespective of other factors; 
*     the ebi is the job residual controlling for other factors
est restore m2
capture drop p4
gen p4 = _b[_cons]   ///
    + ebi + (_b[c_labhours]+ebs)*c_labhours  /* Empirical bayes adjusted linear predictor */

capture drop p4l
gen p4l = _b[_cons] + _b[c_labhours]*c_labhours   /* Linear predictor */

sort soc c_labhours
graph twoway (scatter logincome c_labhours, mcolor(gs10) msymbol(smcircle) msize(vsmall) ) /// 
    (line p4 c_labhours, connect(ascending)  lwidth(thin) lcolor(gs4) lpattern(solid) ) ///
    (line p4l c_labhours, sort  lwidth(thick) lcolor(orange) lpattern(solid) )  ///
     , xtitle("Labour Hours") ytitle("Labour income") title("Random coefficients") ///
    legend(cols(2) order(2 3) label(2 "qpsu resids") label(3 "Overall")  )  

graph save "bit4.gph", replace



graph combine "bit1.gph" "bit2.gph" "bit3.gph" "bit4.gph" ///
   , cols(2) title("Labour income for individuals clustered in occupations") ///
    note("Source: BHPS, adults in work in Wave A (1991)") 
	  
