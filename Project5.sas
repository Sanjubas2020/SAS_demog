/*Project 5A: Demographic: Create summary Tables (Reports)*/


data balance;
input ID $ month $ checking saving;
datalines;
A 2016_06 100 10
A 2016_07 200 .
A 2016_08 .   30
B 2016_06 200 20
B 2016_07 300 30
C 2016_09  .  .
;
run;

proc sql;
select id, count (id) as num_of_months, avg (checking) as avg_checking, avg (saving) as avg_saving
from balance
group by id;
quit;



Proc import datafile='C:\Users\Owner\Desktop\RAng\Project\aaa.xlsX' dbms=xlsX out=aa1 replace;
run;



options symbolgen mprint;
%MACRO RANG (stat=, age=, date=);
title1 "Detail listing of account state &stat.  Run Date:  &sysdate9. "; 
title2 "age &age.    tranyear &date";
data aa2;
set aa1;
where state in &stat. and year (last_tran_date)= &date.;
 age=round(yrdif(birthday, today()),1);
 if age &age.;
 run;

proc print data=aa2 (drop=state) noobs;
var name age Balance Last_tran_Date;
sum balance;
run;
%MEND rang;

%rang (stat=('CA', 'NY'), age=>18, date=2016)



