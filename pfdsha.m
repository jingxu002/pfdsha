function pfd=pfdsha(sc,seg,gfd)
% PFDSHA: COMPUTE THE ANNUAL PROBABILITY OF DISPLACEMENT ON SITE SC LAGER THAN GIVEN FAULT DISPLACEMENT GFD BY FAULT SEGMENT SEG
% Writer: JingXu   Date:2016-09-03    Version: 1.0
% Define Variables:
%{
	sc		site coordinate, unit: km
	seg		fault segment parameter, structure variable, tow fields, coor & seis, coordinate unit: km, seis, mu1,p1...,mun,pn, m0,vm0,beta
	gfd		given fault displacement, unit: cm
	pfd		annual probability of fault displacement exceedance gfd
%}
% local variables:
%{
	tydis		type of displacement, principal or distributed
	jsc		index of site coordinate
	mu 		maximum magnitude, Mw
	nmu		number of maximum magnitude
	pmu		probability of maximum magnitude
	m0  		minimum magnitude, Mw
	vm0		annual frequency of magnitude larger than m0
	beta		parameter value of \beta in G-R relationship
	degr		denominator in G-R relationship
	nm		number of magnitude bin
	mbl	 	magnitude bin length, Mw
	prup		probability of rupture to surface
	parup		parameters for computing prup
	r		nearest distance from off-fault site to fault trace,unit: meter
%}

load fdpe
mbl=0.2;
tydis=prin_or_dist(sc,seg.coor);
pfd=zeros(size(gfd));

for imu=1:nmu
	mu=seg.seis(2*imu-1);
	pmu=seg.seis(2*imu);
	m0=seg.seis(2*nmu+1);
	vm0=seg.seis(2*nmu+2);
	beta=seg.seis(2*nmu+3);
	degr=1/(exp(-beta*m0)-exp(-beta*mu));
	nm=ceil((mu-m0)/mbl);  % magnitude bin length: mbl Mw
  for im=1:nm
	  pm=pmu*(exp(-beta*(m0+mbl*im-mbl))-exp(-beta*(m0+mbl*im)))*degr;
	  m=m0+im*mbl-mbl/2;
	  srl=10^();
	if strcmp(tydis(sc),'principal')==1
		parup=fdpe(1).rup;
	  	prup=exp(parup(1)+m*parup(2))/(1+exp(parup(1)+m*parup(2)));
	else
		r=distance(sc,seg.coor);
		parup=fdpe(2).rup;
		prup=exp(parup(1)*log(r)+parup(2)); % r: nearest distance from site to fault;
	end
    for il=1:nepl
      for id=1:nepd
	pfd=pmu*pm*pepl*pepd*prup*p(sl|rup)*p(d>gfd);
      end
    end
  end
end

function nd=distance(sc,fault)
% DISTANCE: SUBFUNCTION TO CALCULATE THE NEAREST DISTANCE FROM SITE TO FAULT TRACE
% Define variables:
%{
	sc		site coordinate, unit: km
	fault 		fault trace, unit: km
	nd 		nearest distance from site to fault, nuit: meter
%}


