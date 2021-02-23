data eu_occ_total;
	set pg1.eu_occ;
/*	konwersja z tekstu na liczbe: funkcja input*/
	Year = input(substr(YearMon,1,4), 4.);
	Month = input(substr(YearMon,6,2), 2.);
	ReportDate = MDY(Month,1,Year);
	Total = sum(Hotel, ShortStay, Camp);
	format Hotel ShortStay Camp Total comma17. ReportDate monyy7.;
	keep Country Hotel ShortStay Camp ReportDate Total;
run;

data np_summary2;
	set pg1.np_summary;
	ParkType = scan(ParkName, -1);
	keep Reg Type ParkName ParkType;
run;