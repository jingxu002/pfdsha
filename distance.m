function [nd,sc_pd]=distance(sc,fault,strike)
% DISTANCE: CALCULATE THE NEAREST DISTANCE FROM SITE TO FAULT TRACE
% Writer: JingXu    Date: 2016-09-27   Version: 2.0
% Define variables:
%{
	sc		site coordinate, unit: km
	fault 		fault trace, unit: km, 2 columns, 2D matrix, unit: km
	nd 		nearest distance from site to fault, nuit: meter
    sc_pd   foot of perpendicular of site on fault line segment, unit: km
%}
% Local variables:
%{
	nd_init     initial value of nearest distance
    ndjj        temp value of nearest distance, unit: km
                the perpendicular distance from site to fault line segment jj
    pa          the length of line PA, unit: km
    ah          the length of line ah, unit: km
%}
% Algorithm:
%{
    The angle of PAB and PBA must be less or equal to 90, then the site point P,
have a foot of perpendicular on faul line segment AB.
%}


[nr,nc]=size(fault);
if nc~=2 && nr==2
  fault=fault';
elseif nc~=2 && nr~=2
  error('Fault coordinate must be a 2 columns 2D maxtrix !');
end
[nr,nc]=size(fault);
nd_init=ones(nr-1,1); % initial value of nearest distance, 
for jj=1:nr-1
    ndjj=nearestdistance(sc,fault(jj,:),fault(jj+1,:));
    nd_init(jj)=ndjj;   
end
[nd,indr]=min(nd_init); % index of nearest distance
pa=norm(fault(indr,:)-sc);
ah=sqrt(pa^2-nd^2);
sc_pd=fault(indr,:)+ah*[cos(strike(indr)),sin(strike(indr))];
nd=nd*1000;


function nd=nearestdistance(p0,p1,p2)
% SUBFUNCTION NEARDISTANCE: CMPUTE THE NEAREST DISTANCE FROM POINT P0 TO LINE SEGMENT COMPOSITE BY POINTS OF P1 AND P2
% Define variables:
%{
	p0		coordinate of point 0, unit: km
	p1,p2		coordinate of point 1 and 2, composite a line segment, unit: km
	nd		nearest distance, unit: km
    inda    index of angle, than, if have a obtuse angle
%}
% Local variables:
%{
	p10,p20,p21		vector of line p1p0,p2p0,p2p1
	cos01,cos02		cosine of angle between p1p0,p2p1  p2p0,p1p2
%}
% Algorithm:
%{
	if one angle is lager than 90, than the nearest distance is the shorter boundary;
	else the hight of boundary p1p2 is the nearest distance.
%}
p10=p1-p0;
p20=p2-p0;
p21=p2-p1;

cos01=sum(-p10.*p21); % no need to calculate cosine, just need to know whether less than ZERO
cos02=sum(p20.*p21);
inda=cos01*cos02;
if inda<0
  nd=1e6;
else
  nd=abs(det([p10;p20]))/norm(p21);
end
