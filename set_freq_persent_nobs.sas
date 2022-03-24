data dummy;
	input num @@;
	CARDS;
	1
	2
	3
	4
	;
run;

%macro set_freq(inds,var);
	proc sort data = &inds. out= &inds.a nodupkey ; by SUBJID;run;
	proc freq data= &inds.a noprint;
		table &var./out=&inds._out;
	run;
	
	%set_excel_percent(&inds._out);
	data &inds._out3;
		set &inds._out2;
		length VAL0 $20.;
		VAL0 = compress((count||PER2));
	run;
	data &inds.out4;
		set &inds._out3;
		if &var = "xxx" then num=1;
	run;
	proc sort data=&inds. ;by num;run;
	data &inds_out5;
		merge dummy &inds._out4;
		by num;
		if val0="" then VAL0="0(0.0%)";
	run;
	/*レコード数を数える*/
	proc contents data = &inds. noprint out= temp_class_1;
	run;
	data &inds._temp;
		set temp_calss_1;
		keep NOBS;
	run;
	data &inds._nobs;
		set &inds._temp;
		VAL0=put(NOBS,8.);
	run;
	data &var._&inds._res;
		length VAL0 $20.;
		set &inds._nobs &inds._out5;
	run;
%MEND;
%macro set_excel_percent(inds);
	data &inds.2 ;
              set &inds. ;
              per2 = compress("("|| put(round(PERCENT,0.1),8.1) || "%)");
       run;
%mend;