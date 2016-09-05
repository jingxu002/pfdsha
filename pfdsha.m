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


%}

tydis=prin_or_dist(sc,seg.coor);
if comstr(tydis,'principal')
  'load the principal displacement parameters! '
else
  'load the distributed displacement parameters! '
end


pfd=zeros(size(gfd));
for imu=1:nmu
  for im=1:nm
    for il=1:nepl
      for id=1:nepd
	pfd=pmu*pm*pepl*pepd*prup*p(sl|rup)*p(d>gfd);
      end
    end
  end
end


