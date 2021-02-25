%let path=/opt/sas/Workshop/danePGDevOps/LWPG1V2/data_old;

libname np_park xlsx "&path/np_info.xlsx";

data parks;
	set np_park.visits(obs=10);
run;

libname np_park clear;

proc import file="&path/np_info.xlsx" out=tab1 dbms=xlsx replace;
	sheet=visits;
run;

proc import file="&path/np_traffic.csv" out=np_traffic dbms=csv replace;
run;

data np_traffic;
	infile "&path/np_traffic.csv" firstobs=2 dlm=',';
	input ParkName :$30. UnitCode :$30. ParkType :$30. 
		Region :$30. TrafficCounter :$30. 
		ReportingDate :date9. TrafficCount;
	format ReportingDate ddmmyy10.;
	repMonths=intck('month', ReportingDate, today(),'c');
run;

%let pathPD3 =/opt/sas/Workshop/danePGDevOps/PD3;

data osoby2;
	infile "&pathPD3/osoby2.txt";
	input id 1 height 2-4 weight 5-6 sex $ 7 age 8-9 name $ +1;
run;

data pracownicy;
	infile "&pathPD3/pracownicy.txt";
	input id :1. nazwisko $ :20. imie $ :15. kod$ :2. dataUr :ddmmyy8.;
	input id2 :1 x :4. dataZ :ddmmyy8. plec $ :1.;

	nazwisko = propcase(nazwisko);
	imie = propcase(imie);

	format dataUr dataZ ddmmyy10.;
	drop id2 x;
run;