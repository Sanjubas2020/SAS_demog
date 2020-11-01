proc import datafile='/home/u45022572/country.xlsx' out=ct
dbms=xlsx replace;
sheet='Data'n;
run;



options symbolgen mlogic mprint;
%macro a(input=,input1=,output=);
proc sql;
create table &input1. as
select count(distinct(country)) as counts from &input.;
quit;

data _null_;
set &input1.;
call symputx('n',counts);
run;

proc sql;
select distinct(country) into:cc1-:cc&n.  from &input.; 
quit;

%do i=1 %to &n.;
data &output._&i. ;
set &input.;
where country="&cc&i";
run;
%end;
%mend;

%a(input=ct,input1=aa,output=ds);