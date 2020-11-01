/*Project 1-1: Demographic: Create summary Tables (Reports)*/

Proc import datafile='C:\Users\Owner\Desktop\RAng\Project\ADae.xls' dbms=xls out=adae1 replace;
run;

proc contents data=adae1;
run;

data adae2;
   set adae1(keep = usubjid aebodsys aetoxgr saffl trta);
     where saffl = 'Y';
run;

proc sort data=adae2 out=adae3 (drop=saffl);
by usubjid aebodsys aetoxgr;
run;


data adae4;
  set adae3;
  by usubjid aebodsys;
  if last.aebodsys;
  run;


/***************aebodsys*******/

proc freq data=adae2 noprint;
tables aebodsys*trta / out=bsys1 (drop=percent);
run;

 proc sort data=bsys1 out=bsys2;
 by aebodsys;
 run;

 proc transpose data=bsys2 out=bsys3 (drop=_label_ _name_);
 by aebodsys;
 id Trta;
 var count;
 run;


data ds1;
set bsys3 (rename=(aebodsys=aedecod));
run;


/************Aedecod********/


data cod1;
   set adae1(keep = usubjid aedecod aetoxgr saffl trta);
     where saffl = 'Y';
run;

proc sort data=cod1 out=cod2 (drop=saffl);
by usubjid aedecod aetoxgr;
run;


data cod3;
  set cod2;
  by usubjid aedecod;
  if last.aedecod;
  run;


proc freq data=cod1 noprint;
tables aedecod*trta / out=cod6(drop=percent);
run;

 proc sort data=cod6 out=cod7;
 by aedecod;
 run;

 proc transpose data=cod6 out= cod7 (drop=_label_ _name_);
 by aedecod;
 id Trta;
 var count;
 run;


data ds2;
set cod7;
run;


data task2;
set ds1 ds2;
run;

proc sort data=task2 out=task3;
by aedecod 'Active Drug A'n;
run;

proc sql noprint;
select count (distinct USUBJID) into :trt1 from cod1 where trta = "Active Drug A" ;
select count (distinct USUBJID) into :trt2 from cod1 where trta = "Placebo" ;
%put &=trt1 &=trt2;
quit;

data task4;
 set task3;
 pdruga= 'Active Drug A'n/28;
 pplacebo= Placebo/27;
 if 'Active Drug A'n  = . then 'Active Drug A'n =0;
 if Placebo = . then Placebo =0;
 if pPlacebo = . then pPlacebo =0;
 if Pdruga = . then Pdruga =0;
 format pPlacebo pdruga 10.1;
 run;

data task5;
  set task4;
  place='Active Drug A'n ||" ("||pdruga||")";
  tra=placebo ||" ("||pplacebo||")";
  drop 'Active Drug A'n Placebo pdruga pplacebo;
  run;

data task5;
  set task4;
  place='Active Drug A'n ||" ("||pdruga||")";
  tra=placebo ||" ("||pplacebo||")";
  drop 'Active Drug A'n Placebo pdruga pplacebo;
  format Placebo pdruga 10.1;
  run;


ods pdf file='C:\Users\Owner\Desktop\RAng\project\project2.pdf';
proc report data=task5 nowd headline headskip split="@"
style(header)={background=#A9A9A9 foreground=blue}
style(column)={background=#D3D3D3};
define aedecod/"system Organ class (%) @ Preferred Term (%)"  width=50 CENTER;
define place/"Placebo @ (N= %cmpres(&trt1.))"  width=50 CENTER ;
define tra / "Treatnet Group A @ (N=%cmpres(&trt2))" width=30 center ;
title1 "Safety Population";
run;


