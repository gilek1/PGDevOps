data suv_upto_30000;
	set sashelp.cars;
	where type = "SUV" and msrp <= 30000;
run;

/* Uzycie formatow */
data class_bd;
	set pg1.class_birthdate;
	format Birthdate ddmmyyd10.; /* myslikamidata 'd' */
	where Birthdate >= "01sep2005"d;
run;

/*Sortowanie danych CTRL+/ */
proc sort data=class_bd out=class_bd_srt;
	by Birthdate;
run;

/*sortowanie rosnaco po wieku i rosnaco po wzroscie*/
proc sort data=class_bd out=class_bd_srt;
	by age Height;
run;

/*sortowanie rosnaco po wieku i malejaco po wzroscie*/
proc sort data=class_bd out=class_bd_srt;
	by age DESCENDING Height;
run;

/*usuwanie duplikatow*/
proc sort data=pg1.class_test3 out=class_test3_clean nodupkey dupout=class_test3_dups;
/*	by Name Subject TestScore;*/
	by _all_; /*wez wszystkie kolumny*/
run;

/*Przetwarzanie danych w data step*/
data class_bd;
	set pg1.class_birthdate;
	format Birthdate ddmmyyd10.;
	where Birthdate >= "01sep2005"d;
	drop Age /* nie bedzie wyswietlana */
run;

/*Drop jako opcja zbioru ma plus wydajnosciowy*/
data class_bd;
	set pg1.class_birthdate(drop=age);
	format Birthdate ddmmyyd10.;
	where Birthdate >= "01sep2005"d;
run;

data cars_avg;
	format mpg_mean 5.2;
	set sashelp.cars;
	mpg_mean = mean(mpg_city, mpg_highway);
run;

data storm_avg;
	set pg1.storm_range;
	windAvg = mean(of wind1-wind4);
run;

data storm_avg;
	set pg1.storm_range;
	windAvg = mean(of wind:);
/*	drop wind:; */
/*	':' - dowolne znaki*/
	drop wind1-wind4
run;

/*wyrazenia warunkowe*/
data cars_categories;
	set sashelp.cars;
	if MSRP <= 30000 then
		num_category = 1;
	if MSRP <= 60000 then
		num_category = 2;
	else num_category = 3;
run;

data Basic Luxury Extra_Luxury; /*Trzy zbiory kazdy mozna przegladac osobno*/
	set sashelp.cars;
	length car_category $12; /*Zmienne znakowe $ na poczatku*/
	if MSRP <= 40000 then do;
		Cost_Group = 1;
		car_category="Basic";
		output Basic;
	end;
	else if MSRP<= 60000 then do;
		Cost_Group = 2;
		car_category="Luxury";
		output Luxury;
	end;
	else do;
		Cost_Group = 3;
		car_category="Extra Luxury";
		output Extra_Luxury;
	end;		
run;

/*zlaczenie danych w sql*/
proc sql;
	CREATE TABLE class_grades AS
	SELECT t.name, Sex, Age, Teacher, Grade
	FROM pg1.class_teachers as t INNER JOIN pg1.class_update as c
	ON t.name=c.name;
quit;


proc sql;
	SELECT coalesce(t.name, c.name) as Name, Sex, Age, Teacher, Grade
	FROM pg1.class_teachers as t 
	FULL JOIN pg1.class_update as c
	ON t.name=c.name;
quit;