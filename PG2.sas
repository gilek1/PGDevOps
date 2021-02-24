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