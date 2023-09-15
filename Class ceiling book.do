
/// The Class Ceiling Replication placing Ceiling Effects in Temporal Context ///



codebook a_pasoc10_cc a_panssec8_dv a_masoc10_cc a_manssec8_dv a_jbnssec8_dv a_jbsoc10_cc a_fimnlabgrs_dv a_dvage a_birthy a_sex a_racel a_plbornc a_qfhigh_dv a_health a_sf1 a_gor_dv a_jbiindb_dv a_jbsect a_jbsectpub a_jbsize a_jbft_dv, compact


*Re-coding*

tab a_panssec8_dv

gen nssecf=. 
replace nssecf=1 if(a_panssec8_dv==1)
replace nssecf=2 if(a_panssec8_dv==2)
replace nssecf=3 if(a_panssec8_dv==3)
replace nssecf=4 if(a_panssec8_dv==4)
replace nssecf=5 if(a_panssec8_dv==5)
replace nssecf=6 if(a_panssec8_dv==6)
replace nssecf=7 if(a_panssec8_dv==7)
replace nssecf=8 if(a_panssec8_dv==8)

label define nssec_lbl 1"Large employers & higher management" 2"Higher professional" 3"Lower management & professional" 4"Intermediate" 5"Small employers & own account" 6"Lower supervisory & technical" 7"Semi-routine" 8"Routine"
label values nssecf nssec_lbl

tab nssecf

tab a_manssec8_dv

gen nssecm=.
replace nssecm=1 if(a_manssec8_dv==1)
replace nssecm=2 if(a_manssec8_dv==2)
replace nssecm=3 if(a_manssec8_dv==3)
replace nssecm=4 if(a_manssec8_dv==4)
replace nssecm=5 if(a_manssec8_dv==5)
replace nssecm=6 if(a_manssec8_dv==6)
replace nssecm=7 if(a_manssec8_dv==7)
replace nssecm=8 if(a_manssec8_dv==8)

label values nssecm nssec_lbl

tab nssecm

gen nssecdom=.
replace nssecdom=1 if(nssecf==1)
replace nssecdom=1 if(nssecf==. & nssecm==1)
replace nssecdom=2 if(nssecf==2)
replace nssecdom=2 if(nssecf==. & nssecm==2)
replace nssecdom=3 if(nssecf==3)
replace nssecdom=3 if(nssecf==. & nssecm==3)
replace nssecdom=4 if(nssecf==4)
replace nssecdom=4 if(nssecf==. & nssecm==4)
replace nssecdom=5 if(nssecf==5)
replace nssecdom=5 if(nssecf==. & nssecm==5)
replace nssecdom=6 if(nssecf==6)
replace nssecdom=6 if(nssecf==. & nssecm==6)
replace nssecdom=7 if(nssecf==7)
replace nssecdom=7 if(nssecf==. & nssecm==7)
replace nssecdom=8 if(nssecf==8)
replace nssecdom=8 if(nssecf==. & nssecm==8)

label values nssecdom nssec_lbl

tab nssecdom


tab a_jbnssec8_dv

gen curnssec=.
replace curnssec=1 if(a_jbnssec8_dv==1)
replace curnssec=2 if(a_jbnssec8_dv==2)
replace curnssec=3 if(a_jbnssec8_dv==3)
replace curnssec=4 if(a_jbnssec8_dv==4)
replace curnssec=5 if(a_jbnssec8_dv==5)
replace curnssec=6 if(a_jbnssec8_dv==6)
replace curnssec=7 if(a_jbnssec8_dv==7)
replace curnssec=8 if(a_jbnssec8_dv==8)

label values curnssec nssec_lbl

tab curnssec

summarize a_fimnlabgrs_dv

*generate yearly income*
gen labincome = a_fimnlabgrs_dv
replace labincome=. if (labincome<10)
gen yearlyincome= labincome*12

*generate yearly income adjusted for inflation to be comparable to 2016 LFS figures*
*To create inflation adjusted figure, yearlyincome is * by the CPI of 2016/ CPI of 1991
gen adjincome = yearlyincome*100.660/60.060

*generate log income?*
gen logincome = log(yearlyincome)

summarize a_dvage

gen nage = a_dvage
replace nage=. if (nage<23)
replace nage=. if (nage>69)

summarize nage, detail
gen c_age=nage - r(min)

gen c_age2=c_age^2

summarize c_age c_age2

tab a_racel

gen ethnic=.
replace ethnic=1 if(a_racel==1)
replace ethnic=1 if(a_racel==2)
replace ethnic=1 if(a_racel==3)
replace ethnic=1 if(a_racel==4)
replace ethnic=2 if(a_racel==5)
replace ethnic=2 if(a_racel==6)
replace ethnic=2 if(a_racel==7)
replace ethnic=2 if(a_racel==8)
replace ethnic=3 if(a_racel==9)
replace ethnic=4 if(a_racel==10)
replace ethnic=4 if(a_racel==11)
replace ethnic=5 if(a_racel==12)
replace ethnic=6 if(a_racel==13)
replace ethnic=7 if(a_racel==14)
replace ethnic=7 if(a_racel==15)
replace ethnic=7 if(a_racel==16)
replace ethnic=8 if(a_racel==17)
replace ethnic=8 if(a_racel==18)

label define ethnic_lbl 1"White" 2"Mixed/Multiple Ethnic Groups" 3"Indian" 4"Pakistani and Bangladeshi" 5"Chinese" 6"Any other Asian Background" 7"Black/African/Carribean/Black British" 8"Other" 
label values ethnic ethnic_lbl

tab ethnic

tab a_sex

gen sex=a_sex

tab a_plbornc

gen pob=.
replace pob=1 if(a_plbornc==-8)
replace pob=2 if(a_plbornc==5)
replace pob=3 if(a_plbornc==6)
replace pob=4 if(a_plbornc==7)
replace pob=5 if(a_plbornc==8)
replace pob=6 if(a_plbornc==9)
replace pob=7 if(a_plbornc==10)
replace pob=8 if(a_plbornc==11)
replace pob=9 if(a_plbornc==12)
replace pob=10 if(a_plbornc==13)
replace pob=11 if(a_plbornc==14)
replace pob=12 if(a_plbornc==15)
replace pob=13 if(a_plbornc==16)
replace pob=14 if(a_plbornc==17)
replace pob=15 if(a_plbornc==18)
replace pob=16 if(a_plbornc==19)
replace pob=17 if(a_plbornc==20)
replace pob=18 if(a_plbornc==21)
replace pob=19 if(a_plbornc==22)
replace pob=20 if(a_plbornc==23)
replace pob=21 if(a_plbornc==24)
replace pob=22 if(a_plbornc==25)
replace pob=23 if(a_plbornc==26)
replace pob=24 if(a_plbornc==27)
replace pob=25 if(a_plbornc==28)

label define pob_lbl 1"UK" 2"republic of ireland" 3"france" 4"germany" 5"italy" 6"spain" 7"poland" 8"cyprus" 9"turkey" 10"australia" 11"new zealand" 12"canada" 13"u.s.a" 14"china/hong kong" 15"india" 16"pakistan" 17"bangladesh" 18"sri lanka" 19"kenya" 20"ghana" 21"nigeria" 22"uganda" 23"south africa" 24"jamaica" 25"other"
label values pob pob_lbl

tab pob

tab a_health

gen healthy=.
replace healthy=1 if(a_health==1)
replace healthy=2 if(a_health==2)

label define healthy_lbl 1"yes" 2"no"
label values healthy healthy_lbl

tab healthy

tab a_sf1

gen genhealth=a_sf1
replace genhealth=. if(genhealth<1)

label define genhealth_lbl 1"excellent" 2"very good" 3"good" 4"fair" 5"poor"
label values genhealth genhealth_lbl


tab a_qfhigh_dv

gen hed=.
replace hed=1 if(a_qfhigh_dv==1)
replace hed=1 if(a_qfhigh_dv==2)
replace hed=1 if(a_qfhigh_dv==3)
replace hed=1 if(a_qfhigh_dv==4)
replace hed=1 if(a_qfhigh_dv==5)

replace hed=2 if(a_qfhigh_dv==7)
replace hed=2 if(a_qfhigh_dv==8)
replace hed=2 if(a_qfhigh_dv==9)
replace hed=2 if(a_qfhigh_dv==10)
replace hed=2 if(a_qfhigh_dv==11)

replace hed=3 if(a_qfhigh_dv==12)
replace hed=3 if(a_qfhigh_dv==13)
replace hed=3 if(a_qfhigh_dv==14)
replace hed=3 if(a_qfhigh_dv==15)
replace hed=4 if(a_qfhigh_dv==16)
replace hed=4 if(a_qfhigh_dv==96)

label define hed_lbl 1"degree" 2"A level" 3"O level" 4"Other"
label values hed hed_lbl

tab hed

summarize a_jbhrs

gen labhours = a_jbhrs 
replace labhours=. if (labhours<1)

summarize labhours, detail
gen c_labhours=labhours - r(min)

tab a_gor_dv

tab a_jbsect 

tab a_jbsectpub

gen sector=.
replace sector=1 if(a_jbsect==1)
replace sector=1 if(a_jbsect==2)
replace sector=2 if(a_jbsectpub>1)

label define sector_lbl 1"private" 2"public"
label values sector sector_lbl

tab sector


tab a_jbiindb_dv 

gen industry=a_jbiindb_dv
replace industry=. if(industry==-9)
replace industry=. if(industry==-1)
replace industry=. if(industry==0)

replace industry=2 if(industry==1)
replace industry=2 if(industry==2)

replace industry=1 if(industry==27)
replace industry=1 if(industry==28)
replace industry=1 if(industry==33)


replace industry=3 if(industry==3)

replace industry=4 if(industry==4)
replace industry=4 if(industry==5)
replace industry=4 if(industry==6)
replace industry=4 if(industry==7)
replace industry=4 if(industry==8)
replace industry=4 if(industry==9)
replace industry=4 if(industry==10)
replace industry=4 if(industry==11)
replace industry=4 if(industry==12)
replace industry=4 if(industry==13)

replace industry=5 if(industry==14)
replace industry=5 if(industry==15)

replace industry=6 if(industry==16)
replace industry=6 if(industry==17)
replace industry=6 if(industry==18)
replace industry=6 if(industry==24)

replace industry=7 if(industry==19)
replace industry=7 if(industry==20)
replace industry=7 if(industry==21)

replace industry=8 if(industry==22)
replace industry=8 if(industry==23)
replace industry=8 if(industry==25)

replace industry=9 if(industry==26)
replace industry=9 if(industry==29)
replace industry=9 if(industry==30)
replace industry=9 if(industry==31)
replace industry=9 if(industry==32)
replace industry=9 if(industry==34)


label define industry_lbl 1"Public Admin, education, and health" 2"Agriculture, forestry, and fishing" 3"Energy and water" 4"Manufacturing" 5"Construction" 6"Distribution, hotels, and restaurants" 7"Transport and Communication" 8"Banking and finance" 9"Other services" 
label values industry industry_lbl

tab industry


tab a_jbsize 

gen size=a_jbsize 
replace size=. if(size<1)
replace size=. if(size==10)
replace size=. if(size==11)

replace size=1 if(size<3)
replace size=2 if(size==4)
replace size=3 if(size==5)
replace size=3 if(size==6)
replace size=3 if(size==7)
replace size=4 if(size>7)

label define size_lbl 1"Less than 25" 2"25-49" 3"50-499" 4"500+"
label values size size_lbl

tab size

tab a_jbsoc00_cc





codebook adjincome yearlyincome nssecdom c_age c_age2 ethnic sex pob healthy genhealth hed c_labhours a_gor_dv curnssec sector industry size a_jbsoc00_cc, compact

keep adjincome nssecdom c_age c_age2 ethnic sex pob healthy genhealth hed c_labhours a_gor_dv curnssec sector industry size a_jbsoc00_cc yearlyincome

egen miss1=rmiss(adjincome nssecdom c_age c_age2 ethnic sex pob healthy genhealth hed c_labhours a_gor_dv curnssec sector industry size a_jbsoc00_cc)
tab miss1
keep if miss1==0

numlabel _all, add

codebook adjincome nssecdom c_age c_age2 ethnic sex pob healthy genhealth hed c_labhours a_gor_dv curnssec sector industry size a_jbsoc00_cc, compact

label variable yearlyincome "Yearly Labour Income"
label variable adjincome "Yearly Labour Income Adjusted for 2016 Inflation"
label variable nssecdom "Semi-Dominant NS-SEC Social Origins"
label variable c_age "Age Centered"
label variable c_age2 "Age Centered Squared"
label variable ethnic "Ethnicity"
label variable sex "Sex"
label variable pob "Place of Birth"
label variable healthy "Serious Health Issue"
label variable genhealth "General Health"
label variable hed "Highest Educational Qualification"
label variable c_labhours "Weekly Labour Hours Centered"
label variable a_gor_dv "Governmental Regions"
label variable curnssec "NS-SEC Current Job"
label variable sector "Public or Private Sector"
label variable industry "Industry of Labour"
label variable size "Number of Employees at Work"

*descriptive statistics*


table (var) (), statistic(fvfrequency nssecdom ethnic sex pob healthy genhealth hed a_gor_dv curnssec sector industry size) ///
					statistic(fvpercent nssecdom ethnic sex pob healthy genhealth hed a_gor_dv curnssec sector industry size) ///
					statistic(mean adjincome c_age c_age2 c_labhours) ///  
					statistic(sd adjincome c_age c_age2 c_labhours) 
					
* Organise the column structure of the table			
collect remap result[fvfrequency mean] = Col[1 1] 
collect remap result[fvpercent sd] = Col[2 2]
* Name the stored results for Mean and SD in the collection
collect get resname = "Mean", tag(Col[1] var[mylabel]) 
collect get resname = "SD", tag(Col[2] var[mylabel])
* collect an empty result to create a blank row in the table. 
collect get empty = "  ", tag(Col[1] var[empty]) 
collect get empty = "  ", tag(Col[2] var[empty])
* collect the sample size from the 'count' command.
count
collect get n = `r(N)', tag(Col[2] var[n])
* specify the order of the contents of our table.
collect layout (var[1.nssecdom 2.nssecdom 3.nssecdom 4.nssecdom 5.nssecdom 6.nssecdom 7.nssecdom 8.nssecdom ///
						1.ethnic 2.ethnic 3.ethnic 4.ethnic 5.ethnic 6.ethnic 7.ethnic 8.ethnic ///
						1.sex 2.sex ///
						1.pob 2.pob 3.pob 4.pob 5.pob 6.pob 7.pob 8.pob 9.pob 10.pob 11.pob 12.pob 13.pob 14.pob 16.pob 17.pob 18.pob 19.pob 20.pob 21.pob 22.pob 23.pob 24.pob ///
						1.healthy 2.healthy ///
						1.genhealth 2.genhealth 3.genhealth 4.genhealth 5.genhealth ///
						1.hed 2.hed 3.hed 4.hed ///
						1.a_gor_dv 2.a_gor_dv 3.a_gor_dv 4.a_gor_dv 5.a_gor_dv 6.a_gor_dv 7.a_gor_dv 8.a_gor_dv 9.a_gor_dv 10.a_gor_dv 11.a_gor_dv 12.a_gor_dv ///
						1.curnssec 2.curnssec 3.curnssec 4.curnssec 5.curnssec 6.curnssec 7.curnssec 8.curnssec ///
						1.sector 2.sector ///
						1.industry 2.industry 3.industry 4.industry 5.industry 6.industry 7.industry 8.industry 9.industry ///
						1.size 2.size 3.size 4.size ////
						empty mylabel ///
						adjincome c_age c_age2 c_labhours ///
						empty n]) (Col[1 2])
* label the columns for the categorical variable (n and %).
collect label levels Col 1 "n" 2 "%"
* drop the title column
collect style header Col, title(hide)
* hide the variable names for the empty row
collect style header var[empty mylabel], level(hide)
collect style row stack, nobinder
* edit the numerical formats of the numbers shown (i.e. number of decimal places).
collect style cell var[nssecdom ethnic sex pob healthy genhealth hed a_gor_dv curnssec sector industry size a_jbsoc00_cc]#Col[1], nformat(%6.0fc) 
collect style cell var[nssecdom ethnic sex pob healthy genhealth hed a_gor_dv curnssec sector industry size a_jbsoc00_cc]#Col[2], nformat(%6.2f) sformat("%s%%") 	
collect style cell var[adjincome c_age c_age2 c_labhours], nformat(%6.2f)
* remove border above row-header and results 
collect style cell border_block[item row-header], border(top, pattern(nil))
* add a title to the table
collect title "Table 1: Descriptive Statistics"
* add a note to the table	
collect note "Source: BHPS, adults in work in Wave A (1991)" 
* Let's take a look at the table now... 
collect preview
* export your finished table to Word
collect export "ccdescstats.docx", replace	


*data vis*

cd "/Users/ScottOatley/Documents/CC Vis"


global gnote "Data from wave 1 UKHLS (Uni. of Essex, Institute for Social and Economic Research, 2022)"

*Hist Example*

separate adjincome, by(sex) gen(revsex)	
tab1 revsex* /* revsex1 = male */ 
			   /* revsex2 = female */

		twoway ///
	(hist revsex1, color(purple%50) bin(5) ///
		legend(label(1 "Male"))) ///
	(hist revsex2, color(orange%50) bin(5)  ///
		legend(label(2 "Female") pos(1) col(1))) 

		twoway ///
	(hist revsex1, color(purple%25) bin(5) ///
		legend(label(1 "{stSerif:Male}"))) ///
	(hist revsex2, color(orange%25) bin(5)  ///
		legend(label(2 "{stSerif:Female}") pos(6) col(2)) /// * lets also get rid of 'Impact' 
		title("{stSerif:Graph 1. Adjusted Annual Labour Income of {bf:Male} and {bf: Female} respondents}", ///
		size(med)) ///
		ytitle("Test", size(vsmall)) ///
	/// * here, rather than typing out what i wnat in the note, i have used 
	/// * a global '$gnote' instead:
	note(`"{it:{fontface "Times New Roman":$gnote}}"', size(small) pos(6)))
	
graph save "/Users/ScottOatley/Documents/CC Vis/sexincome.gph", replace 






*Box Plot Example*
graph box adjincome, over(genhealth) asyvars showyvars leg(off)

graph box adjincome ///
	, over(nssecdom) asyvars showyvars leg(off) ///
	box(1, color(navy%95) lcolor(black)) ///
	box(2, color(cranberry%95) lcolor(black)) ///
	box(3, color(dkorange%95) lcolor(black)) /// 
	box(4, color(forest_green%95) lcolor(black)) ///
	box(5, color(gold%95) lcolor(black)) ///
	box(6, color(lavender%95) lcolor(black)) ///
	box(7, color(sienna%95) lcolor(black)) ///
	box(8, color(emerald%95) lcolor(black)) ///
	marker(1, mcolor(navy%25) mlcolor(black%25) mlwidth(thin) msymbol(diamond)) ///
	marker(2, mcolor(cranberry%25) mlcolor(black%25) mlwidth(thin) msymbol(square)) ///
	marker(3, mcolor(dkorange%25) mlcolor(black%25) mlwidth(thin) msymbol(triangle)) ///
	marker(4, mcolor(forest_green%25) mlcolor(black%25) mlwidth(thin) msymbol(circle)) ///
	title("{stSerif:Graph 2.BMI Distribution by Last Voted Political Party}") ///
	ytitle("BMI Score", size(small)) ///
	note(`"{it:{fontface "Times New Roman":$gnote}}"', size(small) pos(6))
	graph save $path_output/bmi.gph, replace 
	
	
	
	

*model*

tab curnssec nssecdom


regress yearlyincome i.nssecdom c_age c_age2 i.ethnic i.sex i.pob i.healthy i.genhealth i.hed c_labhours ib(8).a_gor_dv i.curnssec i.sector i.industry ib(4).size i.a_jbsoc00_cc

regress adjincome i.nssecdom c_age c_age2 i.ethnic i.sex i.pob i.healthy i.genhealth i.hed c_labhours ib(8).a_gor_dv i.curnssec i.sector i.industry ib(4).size i.a_jbsoc00_cc

est store linearadj

capture drop pr_inc
predict pr_inc

global scatteroptions "mcolor(%15) msize(tiny)"

twoway  ///
	(scatter adjincome c_age, $scatteroptions ) ///
	(scatter pr_inc c_age, $scatteroptions )
	
	
*Model assumptions*

predict resids, resid
sum resid
hist resids, normal

qnorm resids

scatter resids c_age, $scatteroptions

scatter resids a_gor_dv, $scatteroptions



*An individual that has social origins from 1.1, is 23, white, a man, born in the UK, healthy and has excellent general health with a degree from the south east whose job is 1.1 in the private sector in public admin in a firm 500+ and is a corporate manager earns £52915.19 a year compared to their peers.* 














/// This will be a seperate Paper ///
* seeing if a random effects model is needed?*
mixed yearlyincome i.nssecdom c_age c_age2 i.ethnic i.sex i.pob i.healthy i.genhealth i.hed c_labhours i.curnssec i.sector i.industry i.size ///
    ||a_gor_dv:, mle
	
	estat icc
	*not really needed, linear regression better*
	
mixed yearlyincome i.nssecdom c_age c_age2 i.ethnic i.sex i.pob i.healthy i.genhealth i.hed c_labhours i.curnssec i.sector i.industry i.size ///
    ||a_jbsoc00_cc:, mle

		estat icc
		*soc random does seem needed*
	


mixed yearlyincome i.nssecdom c_age c_age2 i.ethnic i.sex i.pob i.healthy i.genhealth i.hed c_labhours i.curnssec i.sector i.industry i.size ///
    ||_all:R.a_jbsoc00_cc ///
    ||_all:R.a_gor_dv, mle
	
