function pgfd=pfdsha(sc,seg,gfd)
% PFDSHA: COMPUTE THE ANNUAL PROBABILITY OF DISPLACEMENT ON SITE SC LAGER THAN GIVEN FAULT DISPLACEMENT GFD BY FAULT SEGMENT SEG
% Calculate only one PFD of one SC of noe GFD, then use bsxfun in programs that cll pfdsha to calculate array SC and GFD
% Writer: JingXu   Date:2016-09-03    Version: 1.0
% Define Variables:
%{
	sc		site coordinate, unit: km
	seg		fault segment parameter, structure variable, tow fields, coor & seis, 
            coordinate unit: km; 
            seis, mu1,p1...,mun,pn, m0,vm0,beta
	gfd		given fault displacement, unit: cm
	pgfd		annual probability of fault displacement exceedance gfd
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
    sc_pd   coordiante of foot of perpendicular of site on fault line segmet, unit: km
    temp_type   tempary type of distance
    inds_sc_pd  index of foot of perpendicular of site on which fault line segment, type: INT
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
	dis_in		distance interval of middle point of surface rupture, unit: km
	ndis		number of distance of middle point of surface rupture, type: INT
	md_sr		coordinate of middle point of surface rupture, unit: km
	dis_md_sr	distance of middle point of surface rupture from vertex point, unit: km	
	pd		point distance on fault from site to middle point of rupture, unit: km
	xl		ratio between distance from nearest vertex of surface rupture to site and surface rupture length 
	expt_disp	expected log displacement, computed by normalized displacement of quadratic model equation(dqun, displacement, quadratic, normalized)
	temp		normalized value of log(gfd/dave), follow a normal distribution				  
	pdgfd		probability of displacement on site (sc), exceedance given fault displacement (gfd)				
	pmd_sr		probability of middle point of surface rupture location
    pfd         annual probability of exceedance given fault displacement (gfd) 
    srl_low     the minmum surface rupture length of magnitude m (Mw), unit: km

%}

dbstop if error

load fdpe.mat
mbl=0.2;
% compute length of fault segment, unit: km
segl=faultlength(seg.coor);
% determine the type of displacement
% and the nearest distance from sc to segment
[tydis_sc,inds_sc]=prin_or_dis(sc,seg.coor);
% compute the attitude of fault segment,
% strike, unit: degree; length, unit: km
[strike, lenpp]=faultattitude(seg.coor);
acc_len=acc_len_fault(lenpp);
% bring in the parameters of fault displacement predictive equation, 
%vfdpe=struct('name',{},'rup',{},'dave',{},'dbi',{},...
%    'dbin',{},'dqun',{}); %#ok<NASGU>
vfdpe=struct(fdpe); %#ok<NASGU>
if strcmp(tydis_sc,'principal')==1
	vfdpe=fdpe(1);
else
	vfdpe=fdpe(2); 
    [r,sc_pd]=distance(sc,seg.coor,strike);
    [temp_type,inds_sc_pd]=prin_or_dis(sc_pd,seg.coor);
end

% epsilon range of surface rupture length
epsrl=-3:0.3:3;
pepsrl=(cdf('normal',epsrl+0.15,0,1)-cdf('normal',epsrl-0.15,0,1))...
/(cdf('normal',3.15,0,1)-cdf('normal',-3.15,0,1));
nep=length(epsrl);

% initial annual probability of fault displacement exceedance given fault displacement GFD 
pfd=zeros(nep,1);
% initial seismicity parameter values
nmu=(length(seg.seis)-3)/2;

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
	  pm=(exp(-beta*(m0+mbl*im-mbl))-exp(-beta*(m0+mbl*im)))*degr;
	  m=m0+im*mbl-mbl/2;   % middle magnitude of corrent magnitude bin
	  dave=wells_dave_ss(m);  % average fault displacement of magnitude m, expected value, unit: cm
	  % log(srl)=a+b*m+epsilon*sigma
      % srl_low=wells_ss(m,-3);  % srl_low: the minmum surface rupture length of magnitude m
      for iep=1:nep
          srl=wells_ss(m,epsrl(iep)); % well_ss: function of surface rupture length of magnitude m(unit: Mw), unit: km 
          if srl>segl
            break;
          else
            % surface rupture length SRL must be less  than fault segment length SEGL, caution! 
			% start to compute pfd !
			% 1st, the probability of rupture
			if strcmp(tydis_sc,'principal')==1 %#ok<ALIGN>
				temp=vfdpe.rup(1)*m+vfdpe.rup(2);
				prup=exp(temp)/(1+exp(temp));
				% 2ed, determine the location of the middle point of surface rupture
				% from (segl-srl)/2, to (segl+srl)/2
				dis_in=min((segl-srl)/20,1);  % distance interval of middle point of surface rupture, unit: km
				ndis=floor((segl-srl)/dis_in);   % number of distance of middle point of surface rupture, type: INT
				dis_md_sr=linspace(srl/2,segl-srl/2,ndis);	% distance of middle point of surface rupture from vertex point, unit: km			
				md_sr=zeros(ndis,2);
				pd=zeros(ndis,1);
				pdgfd=zeros(ndis,1);
				for jd=1:ndis %#ok<ALIGN>
					[md_sr(jd,:),inds_md_sr]=dis2coor(dis_md_sr(jd),seg.coor,strike,acc_len);    % coordinate of middle point of surface rupture, unit: km
					pd(jd)=pd_on_fault_in(sc,md_sr(jd,:),seg.coor,lenpp,inds_sc,inds_md_sr);       % point distance on fault from site to middle point of rupture, unit: km
					% md_sr must be on fault, so do not need to just
					% whether on fault trace, to reduce compute time 
                    if pd(jd)<=srl/2 
					  xl=(srl/2-pd(jd))/(srl);                     % ratio between distance from nearest vertex of surface rupture to site and surface rupture length 
					  expt_disp=vfdpe.dqun(1)*xl^2+vfdpe.dqun(2)*xl+vfdpe.dqun(3);  % expected log displacement, computed by normalized displacement of quadratic model equation(dqun, displacement, quadratic, normalized)
					  temp_log=(log(gfd/dave)-expt_disp)/vfdpe.dqun(4);
					  pdgfd(jd)=1-cdf('normal',temp_log,0,1);         % conditional probability of exceedance given displacement (gfd)
                    end
                end
				pmd_sr=1/ndis;		% probability of middle point of surface rupture location
				pfd(iep,1)=pfd(iep,1)+vm0*pmu*pm*prup*pepsrl(iep)*pmd_sr*sum(pdgfd);   % annual probability of exceedance given fault displacement
			else
				% distributed fault displacement, need to interplot rupture probability or 
				% compute by different equation, use 200x200 grid here, 
				% if need to use different grid, refer to Petersen et al. 2011
				% 1st, probability of rupture, prup
				% the equation of prup of distributed rupture is different from principal rupture 
				if r>=400 %#ok<ALIGN> % unit: meter
					temp=vfdpe.rup(1)*log(r)+vfdpe.rup(2); 
					prup=exp(temp); 
				else
					prup=interp1([0,200,400],[0.925,0.190,0.075],r); 
                end
                % 2ed, determine the location of the middle point of surface rupture
				% from (segl-srl)/2, to (segl+srl)/2
				dis_in=min((segl-srl)/20,1);  % distance interval of middle point of surface rupture, unit: km
				ndis=floor((segl-srl)/dis_in);   % number of distance of middle point of surface rupture, type: INT
				dis_md_sr=linspace(srl/2,segl-srl/2,ndis);	% distance of middle point of surface rupture from vertex point, unit: km			
				md_sr=zeros(ndis,2);
				pd=zeros(ndis,1);
				pdgfd=zeros(ndis,1);
				for jd=1:ndis %#ok<ALIGN>
					[md_sr(jd,:),inds_md_sr]=dis2coor(dis_md_sr(jd),seg.coor,strike,acc_len);    % coordinate of middle point of surface rupture, unit: km
					pd(jd)=pd_on_fault_in(sc_pd,md_sr(jd,:),seg.coor,lenpp,inds_sc_pd,inds_md_sr);       % point distance on fault from site to middle point of rupture, unit: km
					% md_sr must be on fault, so do not need to just
					% whether on fault trace, to reduce compute time 
                    if pd(jd)<=srl/2 
					  expt_disp=vfdpe.dqun(1)*log(r)+vfdpe.dqun(2);  % expected log displacement, computed by normalized displacement of quadratic model equation(dqun, displacement, quadratic, normalized)
					  temp_log=(log(gfd/dave)-expt_disp)/vfdpe.dqun(3);
					  pdgfd(jd)=1-cdf('normal',temp_log,0,1);         % conditional probability of exceedance given displacement (gfd)
                    end
                end
				pmd_sr=1/ndis;		% probability of middle point of surface rupture location
				pfd(iep,1)=pfd(iep,1)+vm0*pmu*pm*prup*pepsrl(iep)*pmd_sr*sum(pdgfd);   % annual probability of exceedance given fault displacement
            end
         end
      end
  end
end

pgfd=sum(pfd);





function pd=pd_on_fault_in(p1,p2,fault,lenpp,inds1,inds2)
% PD_ON_FAULT_IN: SUBFUNCTION TO COMPUTE DISTANCE BETWEEN POINTS ON FAULT TRACE, UNIT: KM
% Writer: JingXu	Date: 2016-09-16	Version: 2.0
% Define Variables:
%{
	p1,p2		points on fault trace, coordinate unit: km
	fault		coordinate of fault trace, unit: km
    lenpp       length of fault line segments, unit: km
    inds1,2     index of points, which fault line segment, the points on
	pd		distance between point p1 and point p2, unit: km
%}
% Local Variables:
%{
	p           composite matrix of point p1 and p2
    nr,nc		number of rows and columns of coordinate of fault trace
    pd1         distance between p1 and vertex of fault line segment inds(1), unit: km
    pd2         distance between p2 and vertex of fault line segment inds(2), unit: km
    pdw         distance between fault line segment inds(1) and inds(2), unit: km
%}

[nr,nc]=size(fault);
if nr~=2 && nc ~=2
  error(' Fault trace must be a 2 column 2D matrix ! ');
elseif nc~=2 && nr==2
  fault=fault';
end




if inds2-inds1>=2
    pd1=norm(p1-fault(inds1+1,:));
    pd2=norm(p2-fault(inds2,:));
    pdw=sum(lenpp(inds1+1:inds2-1));
    pd=pd1+pd2+pdw;
elseif inds1-inds2>=2
    pd2=norm(p2-fault(inds2+1,:));
    pd1=norm(p1-fault(inds1,:));
    pdw=sum(lenpp(inds2+1:inds1-1));
    pd=pd1+pd2+pdw;
elseif inds1==inds2
    pd=norm(p1-p2);
elseif inds2-inds1==1
    pd1=norm(p1-fault(inds1+1,:));
    pd2=norm(p2-fault(inds2,:));
    pd=pd1+pd2;
else
    pd1=norm(p1-fault(inds1,:));
    pd2=norm(p2-fault(inds2+1,:));
    pd=pd1+pd2;
end
