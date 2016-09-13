function pfd=pfdsha(sc,seg,gfd)
% PFDSHA: COMPUTE THE ANNUAL PROBABILITY OF DISPLACEMENT ON SITE SC LAGER THAN GIVEN FAULT DISPLACEMENT GFD BY FAULT SEGMENT SEG
% Calculate only one PFD of one SC of noe GFD, then use bsxfun in programs that cll pfdsha to calculate array SC and GFD
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
	tydis		type of displacement, principal or distributed, cell array of string
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
	pm		probability of magnitude m
	prup		probability of rupture to surface
	parup		parameters of  computing prup
	r		nearest distance from off-fault site to fault trace,unit: meter
	srl 		surface rupture length of strike slip fault, unit: km
	epsrl		epsilon of surface rupture length
	pepsrl		probability of epsilon of surface rupture length
	nep		number of  epsilon of srl/fault displacement
	segl		length of fault segment, unit: km
	vfdpe		value of parameters of fault displacement predictive equation, structure variable,
			have fields of: name, rup, dave, dbi, dbin, corrspond to
			name, probability of surface rupture, average displacement, bilinear equation of displacement, bilinear of normalized displacement
	strike,lenpp	strike, unit: degree, from East, anti-clock wise; length, unit: km, length of line segment between nebour points on fault trace
	nlen		number of length of line segment between points on fault trace
	acc_len		accumulate length of lien segment between points on fault trace, unit: km
%}


load fdpe
mbl=0.2;
% compute length of fault segment, unit: km
segl=faultlength(seg.coor(:,1),seg.coor(:,2));
% determine the type of displacement
tydis=prin_or_dist(sc,seg.coor);
% compute the attitude of fault segment,
% strike, unit: degree; length, unit: km
[strike, lenpp]=faultattitude(seg.coor);
nlen=length(lenpp);
acc_len=ones(nlen,1);
for jj=1:nlen
	acc_len(jj)=sum(lenpp(1:jj));
end
% bring in the parameters of fault displacement predictive equation, 
if srtcmp(tydis{1},'principal')==1
	vfdpe=fdpe(1);
else
	vfdpe=fdpe(2); 
	% the nearest distance from sc to segment
	r=distance(sc,seg.coor);
end

% epsilon range of surface rupture length
epsrl=-3:0.3:3;
pepsrl=(cdf('normal',epsrl+0.15,0,1)-cdf('normal',epsrl-0.15,0,1))...
/(cdf('normal',3.15,0,1)-cdf('normal',-3.15,0,1));
nep=length(epsrl);

% initial annual probability of fault displacement exceedance given fault displacement GFD 
pfd=0.0;

for imu=1:nmu
	% bring seismicity parameters in program
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
	  % log(srl)=a+b*m+epsilon*sigma
	  for iep=1:nep
	 	 srl=wells_ss(m,epsrl(iep)); % well_ss: function of surface rupture length of magnitude m(unit: Mw), unit: km 
		 while srl<=segl
			% surface rupture length SRL must be less  than fault segment length SEGL, caution! 
			% start to compute pfd !
			% 1st, the probability of rupture
			if srtcmp(tydis{1},'principal')==1
				temp=vfdpe.rup(1)*m+vfdpe.rup(2)
				prup=exp(temp)/(1+exp(temp));
				% 2ed, determine the location of the middle point of surface rupture
				% from (segl-srl)/2, to (segl+srl)/2
				s_in=find(acc_len>=(segl-srl)/2, 1, 'first');
				e_in=find(acc_len<=(segl+srl)/2, 1, 'last');
			else
				% distributed fault displacement, need to interplot rupture probability or 
				% compute by different equation, use 200x200 grid here, 
				% if need to use different grid, refer to Petersen et al. 2011
				if r>=400 % unit: meter
					temp=vfdpe.rup(1)*log(r)+vfdpe.rup(2); 
					prup=exp(temp);
				else
					prup=interp1([0,200,400],[0.925,0.190,0.075],r);
				end
			end




		 end

		
    	end
  end
end



