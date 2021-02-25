/*Wyglad logow*/
data storm_summary;
	set pg2.storm_summary(obs=5);
	duration = enddate - startdate;
	putlog "ERROR: duration=" duration;
	putlog "WARNING: " duration=;
	putlog "---------------------";
	putlog _all_; /*wszystkie wartosci zmiennych */
run;

data quiz;
	set pg2.class_quiz;
	avgQuiz = mean(of q:);
/*	format Quiz1-Quiz5 4.1;*/
/*	format _numeric_ 4.1;*/
	format Quiz1--avgQuiz 4.2;
run;

data quiz;
	set pg2.class_quiz;
	putlog "NOTE: przed rutyna";
	putlog _all_;
	call sortn( of Q:);
	putlog "NOTE: po rutynie";
	putlog _all_;
	if mean(of q:) < 7 then
		call missing(of _numeric_);
run;

data quiz;
	set pg2.class_quiz;
	quiz1st = largest(1, of quiz1-quiz5);
	quiz2nd = largest(2, of quiz1-quiz5);
	avgBest = mean(quiz1st, quiz2nd);
	studentId = rand('integer',100,999);
	avg = round(mean(of quiz1-quiz5));
run;

data test;
	a = " ala ";
	call missing(a);
	l1 = length(a);
	l2 = lengthc(a);
	l3 = lengthn(a);
run;

data test;
	length imie imie2 nazwisko $20;
	imie="Katarzyna";
	imie2 = "Barbara";
	nazwisko = "Kowalska";
	fullname = cat(imie, imie2, nazwisko);
	fullname2 = imie !! imie2 || nazwisko;
	fullname3 = catx(" ",imie, imie2, nazwisko);
run;

options locale=pl_pl;

data stocks2;
	set pg2.stocks2(rename=(date=date_old high=high_old volume=volume_old));
	Date = input(date_old, date9.);
	High = input(high_old, best12.);
	Volume = input(volume_old, comma12.);
	format Date ddmmyy10. Volume nlnum12.;
	drop date_old high_old volume_old;
run;

data stocks3;
	set stocks2;
	value_zl = put(Volume, nlmny15.2);
run;

/*1. Skopiuje dane z sashelp.class do work.class*/
/*2. Dolacze dane z pg2.class_new do work.class*/

proc copy in=sashelp out=work;
	select class; /* opcjonalnie zamiast select mozna uzyc exclude
						czyli skopiuj wszystko poza wymienionymi */
run;

data class;
	length name $9;
	set sashelp.class;
run;

proc append base=class data=pg2.class_new;
run;

proc append base=class data=pg2.class_new2(rename=(Student=Name));
run;

proc copy in=pg2 out=work;
	select np_2014;
run;

proc append base= np_2014(rename=(park=parkCode type=ParkType)) data=pg2.np_2015;
run;

proc sql;
	create table klasa like sashelp.class;
quit;

data klasa;
	if 0 then do;
		set sashelp.class;
		output;
	end;
run;

/*laczenie danych*/
data class_grades;
	merge pg2.class_update(in=c) pg2.class_teachers(in=t);
	by name;
	if c=1 and t=1;
run;


/*Przetwarzanie w petlach*/
data petlaDo;
	do i=1 to 10 /*by 2*/;
		los=rand("integer",1,100);
		output;
	end;
run;

data doWhile;
	i = 1;
	do while(i<=10);
		los=rand("integer",1,100);
		output;
		i=i+1;
	end;
run;

data doUntil;
	i=1;
	do until(i>10);
		los=rand("integer",1,100);
		output;
		i=i+1;
	end;
run;

data doList;
	do miesiac="Styczen", "Luty", "Marzec";
		los=rand("integer",1,100);
		output;
	end;
run;

data doList;
	set sashelp.class; /* 19 wierszy */
	do miesiac="Styczen", "Luty", "Marzec";
		los=rand("integer",1,100);
		output;
	end;
run;

/*Transpozycja kolumn*/

proc transpose data= sashelp.class out=classT;
	id name;
	var Height Weight;
run;

proc sort data=sashelp.class out=classS;
	by age;
run;

proc transpose data= sashelp.class out=classT;
	id name;
	var Height Weight;
	by age;
run;

proc transpose data=pg2.storm_top4_narrow prefix=Wind out=storm_top4_wide(drop=_name_);
	id WindRank;
	var WindMPH;
	by season basin name;
run;

proc transpose data=pg2.storm_top4_wide 
		out=storm_top4_narrow(rename=(Col1=WindMPH)) name=WindRank;
	by season basin name;
	var Wind1-Wind4;
run;
