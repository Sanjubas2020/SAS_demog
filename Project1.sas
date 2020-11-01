/*Project 1-1: Demographic: Create summary Tables (Reports)*/

Proc import datafile='C:\Users\Owner\Desktop\RAng\Project\ADSL.xls' dbms=xls out=adsl1;
run;

data adsl2;
   set adsl1(keep = usubjid Age AGegr1 sex race ethnic country pltcnt trt01a trt01p ittfl);
     where ittfl = 'Y';
run;

data adsl3;
  set adsl2;
  output;
  trt01a="Total";
  output;
run;


/***************AGE*******/
proc means data=adsl3;
class Trt01a;
var age;
output out=age1 (drop=_type_ _freq_)
n=_n
mean=_mean
std=_std
min=_min
max =_max
median=_median;
run;



data age2;
 length n mean median minmax stdev $30;
 set age1;
 n= put(_n,5.);
 mean=put(_mean, 2.);
 minmax = put(_min, 2.)|| ","|| put(_max, 2.);
 median=put(_median, 2.);
 stdev= put(_std, 2.);
 if trt01a ne " ";
 drop _n _mean _std _max _min _median;
 run;

proc sort data=age2 out=age3;
by Trt01a;
run;

proc transpose data=age3 out=age4;
id Trt01a;
var n mean minmax stdev;
run;


data lbl;
length _name_ $50;
_name_ = "AGE";
run;

data agefinal;
set lbl age4;
run;


/****age categorization********/
proc freq data=adsl3 noprint;
tables AGegr1*trt01a / out=agegr1 (drop=percent);
run;

proc sql noprint;
select count (distinct USUBJID) into :trt1 from adsl3 where trt01a = "Drug A" ;
select count (distinct USUBJID) into :trt2 from adsl3 where trt01a = "Placebo" ;
select count (distinct USUBJID) into :trt3 from adsl3 where trt01a = "Total" ;
%put &trt1 &trt2 &trt3;
quit;

data agegr2;
 set agegr1;
 if trt01a= "Drug A" then denom=&trt1;
 if trt01a= "Placebo" then denom=&trt2;
 if trt01a= "Total" then denom=&trt3;
 Percent=put((count/denom)*100, 7.1);
 CP=count||" ("||percent||")";
 drop count denom percent;
 run;

 proc sort data=agegr2;
 by agegr1;
 run;

 proc transpose data=agegr2 out=agegr3 (drop=_name_);
 by agegr1;
 id Trt01a;
 var cp;
 run;

data agegr4;
length _name_ $ 100;
set agegr3 (rename=(agegr1=_name_));
run;

data lb1;
_name_ = "AGEGR";
run;

data agegrfinal;
set lb1 agegr4;
run;

data lb2;
LENGTH _NAME_ $50;
_name_ = "NOT";
run;

data agegrfinal1;
LENGTH _NAME_ $50;
set agegrfinal lb2;
run;

/************GENDER********/
proc freq data=adsl3 noprint;
tables sex*trt01a / out=sex1 (drop=percent);
run;

data sex2;
 set sex1;
 if trt01a= "Drug A" then denom=&trt1;
 if trt01a= "Placebo" then denom=&trt2;
 if trt01a= "Total" then denom=&trt3;
 Percent=put((count/denom)*100, 7.1);
 CP=count||" ("||percent||")";
 drop count denom percent;
 run;

 proc sort data=sex2;
 by sex;
 run;

 proc transpose data=sex2 out=sex3 (drop=_name_);
 by sex;
 id Trt01a;
 var cp;
 run;

data sex4;
length sex $50;
  set sex3;
  if sex ="M" then do;
  sex= "Male";
  ord =1;
  end;
  if sex ="F" then do;
  sex= "Female";
  ord=2;
  end;
  run;

proc sort data= sex4(rename=(sex =_name_));
by ord;
run;

data lb1;
_name_ = "Gender";
run;

data sex5;
set lb1 sex4;
drop ord;
run;

data lb2;
_name_ = "NOT";
run;

data sexfinal;
length _name_ $50;
set sex5 lb2;
drop ord;
run;


/************RACE**************/

proc freq data=adsl3 noprint;
tables RACE*trt01a / out=RACE1 (drop=percent);
run;

data race2;
 set race1;
 if trt01a= "Drug A" then denom=&trt1;
 if trt01a= "Placebo" then denom=&trt2;
 if trt01a= "Total" then denom=&trt3;
 Percent=put((count/denom)*100, 7.1);
 CP=count||" ("||percent||")";
 drop count denom percent;
 run;

 proc sort data=race2;
 by race;
 run;

 proc transpose data=race2 out=race3 (drop=_name_);
 by race;
 id Trt01a;
 var cp;
 run;

 data race4;
set race3 (rename=(race=_name_));
if _n_ in ( 2, 3, 6, 7);
run;


data race5;
length _name_ $50;
  set race4;
if _name_= "White" then orderr=1;
if _name_ = "Black" then orderr=2;	
if _name_ = "Asian" then orderr=3;
if _name_ = "Other" then orderr=4;
run;

proc sort data=race5 out=race6 (drop= orderr);
by orderr;
run;

data lb3;
length _name_ $50;
_name_ = "RACE";
run;

data race7;
set lb3 race6;
run;

data lb4;
length _name_ $50;
_name_ = "NOT";
run;

data racefinal;
set race7 lb4;
run;


/******ETHNICITY***************/

proc freq data=adsl3 noprint;
tables ethnic*trt01a / out=ethnic1 (drop=percent);
run;

data ethnic2;
 set ethnic1;
 if trt01a= "Drug A" then denom=&trt1;
 if trt01a= "Placebo" then denom=&trt2;
 if trt01a= "Total" then denom=&trt3;
 Percent=put((count/denom)*100, 7.1);
 CP=count||" ("||percent||")";
 drop count denom percent;
 run;

 proc sort data=ethnic2;
 by ethnic;
 run;

 proc transpose data=ethnic2 out=ethnic3 (drop=_name_);
 by ethnic;
 id Trt01a;
 var cp;
 run;

data lb7;
length _name_ $50;
_name_= "Ethnic";
run;

data ethnic4;
length _name_ $50;
set lb7 ethnic3 (rename=(ethnic=_name_));
run;

data lb5;
_name_ = "NOT";
run;

data ethnicfinal;
set ethnic4 lb5;
 if _NAME_= "Hispanic" then Placebo="          0 (  000.0)";
run;

/*if _n_ gt 1 then _name_= "    " ||_name_;*/
/* if _n_ gt 1 and Placebo= " " then Placebo = "00 ( 00.0)";*/

/**********PLATELET COUNT INFORMATION******/

proc means data=adsl3;
class Trt01a;
var Pltcnt;
output out=plate1 (drop=_type_ _freq_)
n=_n
mean=_mean
std=_std
min=_min
max =_max
median=_median;
run;


data plate2;
 length n mean median minmax stdev $30;
 set plate1;
 n= put(_n,5.);
 mean=put(_mean, 2.);
 minmax = put(_min, 2.)|| ","|| put(_max, 2.);
 median=put(_median, 2.);
 stdev= put(_std, 2.1);
 if trt01a ne " ";
 drop _n _mean _std _max _min _median;
 run;

proc sort data=plate2 out=plate3;
by Trt01a;
run;

proc transpose data=plate3 out=plate4;
id Trt01a;
var n mean minmax stdev;
run;


data plate5;
length _name_ $50;
   set plate4;
   if _name_= "n" then _name_ = "N";
   if _name_= "mean" then _name_ = "MEAN";
   if _name_= "minmax" then _name_ = "MIN, MAX";
   if _name_= "stdev" then _name_ = "STANDARD DEVIATION";
   run;

 data lbl;
length _name_ $50;
_name_ = "PLATELET COUNT";
run;

data platefinal;
length _name_ $50;
set lbl plate5;

run;


  PROC FORMAT;
  VALUE $NAME  "    n"      ="    N"
               "    mean"   ="    MEAN"
			   "    minmax" ="    MIN , MAX"
			   "    stdev"  ="    STANDARD DEVIATION"
               "AGEGR"      ="AGE CATEGORIZATION"
			  "    NOT"= "    NOT REPORTED"
			   "Gender"= "GENDER (%)"
			    "RACE"= "RACE  (%)"
				"White"= "WHITE"
			   "Black"= "BLACK OR AFRICAN AMERICAN"
			    "Asian"= "ASIAN"
				"Other"= "OTHER"
				"Ethnic"="ETHNIC (%)"
				"Hispanic" ="HISPANIC/LATINO"
				"Non-Hisp" ="NOT HISPANIC/LATINO"
				"        STAN" = "        STANDARD DEVIATION";
			  RUN;

/*indentation*/

data report2;
length _name_ $50;
  set agefinal(in=a) agegrfinal1 (in=b) sexfinal (in=c) racefinal (in=d) ethnicfinal (in=e)platefinal (in=f);
  ord=sum(a*1, B*2, C*3, d*4, E*5, f*6);
if _n_ in (2, 3, 4,5, 7,8,9, 11, 12, 13,15, 16 17, 18, 19, 21, 22, 23,25, 26, 27, 28) then _name_= "    "||_name_; 
  run;

/*  format*/
data report3;
length _name_ $50;
  set REPORT2;
FORMAT _NAME_ $NAME.;
  run;

ods pdf file='C:\Users\Owner\Desktop\RAng\Project\Project1.pdf';
proc report data=report3 nowd headline headskip split="@";
column _name_ 'Drug A'n Placebo total ord;
define _name_/"    " width=34 display style=[asis=on];
define 'Drug A'n /"DRUG A@(N=%cmpres(&trt1))" width=30 center;
define Placebo /"PLACEBO@(N=%cmpres(&trt2))" width=30 center;
define Total /"TOTAL@(N=%cmpres(&trt3))" width=30 center;
define ord/noprint order;
compute after ORD;
line 70*" ";
endcomp;
title1 "Demographic and Baseline characteristics summary";
title2 "All Randomized Subjects";
run;
title;
ods pdf close;

























