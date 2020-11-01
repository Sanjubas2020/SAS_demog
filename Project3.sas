/*Project 1-1: Demographic: Create summary Tables (Reports)*/

Proc import datafile='C:\Users\Owner\Desktop\RAng\Project\adrs.xls' dbms=xls out=ads1 replace;
run;

data ads2;
   set ads1(keep = usubjid trt01a avalc paramcd);
     where paramcd = "BOR";
run;

data ads3;
  set ads2;
  output;
  trt01a="Total";
  output;
run;


/****AVALC********/
proc freq data=ads3 noprint;
tables AVALC*trt01a / out=Ads4 (rename =(avalc=varr) drop=percent);
run;

proc sql noprint;
select count (distinct USUBJID) into :trt1 from ads3 where trt01a = "Drug A" ;
select count (distinct USUBJID) into :trt2 from ads3 where trt01a = "Placebo" ;
select count (distinct USUBJID) into :trt3 from ads3 where trt01a = "Total" ;
%put &=trt1 &=trt2 &=trt3;
quit;

data ads5;
 set ads4;
 if trt01a= "Drug A" then denom=&trt1;
 if trt01a= "Placebo" then denom=&trt2;
 if trt01a= "Total" then denom=&trt3;
 Percent=put((count/denom)*100, 7.1);
 CP=count||" ("||percent||")";
 drop count denom percent;
 run;

 proc sort data=ads5 out=ads6;
 by varr;
 run;

 proc transpose data=ads6 out=ads7 (Rename=('Drug A'n = DrugA) drop=_name_);
 by varr;
 id Trt01a;
 var cp;
 run;

data ads8;
  set ads7;
if varr="NE" then delete;
if varr= "CR" then ord =1;
if varr= "PR" then ord =2;
if varr= "SD" then ord =3;
if varr= "PD" then ord =4;
run;

proc sort data=ads8  out=ads9 (drop=ord);
by ord;
run;

data lb20;
LENGTH varr $ 50;
VARR = "BEST";
run;

data ads10;
LENGTH varr $ 50;
set lb20 ads9 ;
run;


data dummy1;
length varr $  50 DrugA $ 22 Placebo $ 22 Total $ 22;
input varr=$ DrugA= Placebo= Total=;
CARDS;
varr= R1 DrugA= 0 (0.0) Placebo= 0 ( 0.0) Total= 0 ( 0.0) 
varr= R2 DrugA= 0 (0.0) Placebo= 0 ( 0.0) Total= 0 ( 0.0) 
varr= R3 DrugA= 0 (0.0) Placebo= 0 ( 0.0) Total= 0 ( 0.0) 
varr= R4 DrugA= 0 (0.0) Placebo= 0 ( 0.0) Total= 0 ( 0.0)
;;
run;

data ADS11;
set ads10 dummy1;
run;

data ADS12;
set ads11;
if _n_ in (7,8,9) then VARR= "    "||VARR; 
run;


proc format;
value $fvarrr  'BEST' = "BEST OVERALL RESPONSE (RECIST 1.1, CONFIRMATION OF RESPONSE REQUIRED):"
               'CR' = "COMPLETE RESPONSE (CR)"
              'PR'= "PARTIAL RESPONSE (PR)"
			   'SD' = "STABLE DISEASE (SD)"
			   'PD' = "PROGRESSIVE DISEASE (PD)"
			   'R1' = "UNABLE TO DETERMINE (UTD)"
               '    R2' = "    REASON UTD 1"
               '    R3' = "    REASON UTD 2"
               '    R4' = "    REASON UTD X";
			   run;


DATA ads13;
  SET ADS12;
  format varr $fvarrr.; 
   RUN;

ods pdf file='C:\Users\Owner\Desktop\RAng\project\project3.pdf';
proc report data=ads13 nowd headline headskip split="@"
style(header)={background=#A9A9A9 foreground=blue}
style(column)={background=#D3D3D3};
column varr ("Number of subjects (%) " DrugA Placebo total);
define varr/"  " width=50 display style=[asis=on];
define DrugA /"DRUG A@(N=%cmpres(&trt1))" width=30 center;
define Placebo /"PLACEBO@(N=%cmpres(&trt2))" width=30 center;
define Total /"TOTAL@(N=%cmpres(&trt3))" width=30 center;

title1 "Best Overall Response per Invistigator";
title2 "All Treated Subjects";
run;

 





