/*Project 1-4: Demographic: Create summary Tables (Reports)*/

Proc import datafile='C:\Users\Owner\Desktop\RAng\Project\adlb.xls' dbms=xls out=adb1 replace;
run;

data adb2 (drop=paramcd saffl);
   set adb1 (keep= trt01a SAFFL paramcd AVISITN_1 aval);
     where SAFFL = "Y" and paramcd = "BGLUCO";
	 AVISITN_2= input(AVISITN_1, $11.);
run;

proc sort data=adb2 out=adb3 (drop=avisitn_1);
by AVISITN_2 Trt01a;
run;


proc means data=adb3 nonobs mean stddev;
class AVISITN_2 Trt01a;
var aval;
output out=adb4 (drop=_type_ _freq_)
mean=_mean
std = _std;
run;

/*Means data*/

proc sort data=adb4;
by AVISITN_2;
run;


proc print data=adb4;
run;

/*freq data*/
proc freq data=adb3 noprint;
tables AVISITN_2*trt01a / out=Adb5 (drop=percent);
run;

proc sort data=adb5;
by AVISITN_2;
run;

data final;
merge adb4 (in=aa)
adb5 (in=bb);
by AVISITN_2;
if aa and bb;
run;


proc sort data=final nodupkey;
by avisitn_2 Trt01a;
run;


data final1;
 set final;
   if AVISITN_2 = "Week 1" then ordd=1;
   if AVISITN_2 = "Week 4" then ordd=2;
   if AVISITN_2 = "Week 8" then ordd=3;
    if AVISITN_2 = "Week 12" then ordd=4;
	 if AVISITN_2 = "Week 16" then ordd=5;
	 ser=put(divide(_mean,sqrt(count)), 5.2);
    ser1=_mean||" ("||ser||")";
 drop _mean _std;
 run;

proc sort data= final1 out=final2 (drop=ordd ser);
by ordd;
run;

ods pdf file='C:\Users\Owner\Desktop\RAng\project\project4.pdf';
proc report data=final2 nowd headline headskip
style(header)={background=#A9A9A9 foreground=blue}
style(column)={background=#D3D3D3};
column AVISITN_2 Trt01a count ser1;
define AVISITN_2/"Test Day" width=34 CENTER;
define TRT01A /"Treatment" width=30 center;
define count /"N" width=30 center;
define ser1 /"Mean (SE)" width=30 center;
title1 "Summary of Blood Glucose Level over time";
title2 "Safety Population";
run;
ods pdf close;
title;






