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

data parks monuments;
	set pg1.np_summary;
	where Type in ('NM','NP');
	Campers = sum(BackcountryCampers,OtherCamping,RVCampers,TentCampers);
	format Campers comma20.;
	length ParkType $8;
	if type='NP' then do;
		ParkType = 'Park';
		output parks;
	end;
	else do;
		ParkType = 'Monument';
		output monuments;
	end;

	keep Reg ParkName DayVisits OtherLodging Campers ParkType;
run;

data parks monuments;
	set pg1.np_summary;
	where Type in ('NM','NP');
	Campers = sum(BackcountryCampers,OtherCamping,RVCampers,TentCampers);
	format Campers comma20.;
	length ParkType $8;
	SELECT (type);
		when ('NP') do;
			ParkType = 'Park';
			output parks;
		end;
		otherwise do;
			ParkType = 'Monument';
			output monuments;
		end;
/*		
		lub po prostu 
		'oterwise;'
*/
	end;

	keep Reg ParkName DayVisits OtherLodging Campers ParkType;
run;