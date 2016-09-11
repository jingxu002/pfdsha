function nd=distance(sc,fault)
% DISTANCE: CALCULATE THE NEAREST DISTANCE FROM SITE TO FAULT TRACE
% Define variables:
%{
	sc		site coordinate, unit: km
	fault 		fault trace, unit: km, 2 columns, 2D matrix, unit: km
	nd 		nearest distance from site to fault, nuit: meter
%}
% Local variables:
%{
	pd		point distance, from sc to points in fault segment,unit: km
	vd,in 		value and indxe of nearest distance from sc to points in fault segment, unit: km
%}


[nr,nc]=size(fault);
if nc~=2 && nr==2
  fault=fault';
elseif nc~=2 && nr~=2
  error('Fault coordinate must be a 2 columns 2D maxtrix !');
end
pd=sqrt((fault(:,1)-sc(1)).^2+(fault(:,2)-sc(2)).^2);
[vd,in]=min(pd);
if in==1
  nd=1000*neardistance(sc,fault(1,:),fault(2,:));
else
  nd=1000*neardistance(sc,fault(in-1,:),fault(in,:));
end


function nd=neardistance(p0,p1,p2)
% SUBFUNCTION NEARDISTANCE: CMPUTE THE NEAREST DISTANCE FROM POINT P0 TWO LINE SEGMENT COMPOSITE BY POINTS OF P1 AND P2
% Define variables:
%{
	p0		coordinate of point 0, unit: km
	p1,p2		coordinate of point 1 and 2, composite a line segment, unit: km
	nd		nearest distance, unit: km
%}
% Local variables:
%{
	p10,p20,p21		vector of line p1p0,p2p0,p2p1
	cos01,cos02		cosine of angle between p1p0,p2p1  p2p0,p1p2
%}
p10=p1-p0;
p20=p2-p0;
p21=p2-p1;

cos01=sum(-p10.*p21); % no need to calculate cosine, just need to know whether less than ZERO
cos02=sum(p20.*p21);
if cos01*cos02<0
  nd=min(norm(p10),norm(p20));
else
  nd=abs(det([p10;p20]))/norm(p21);
end
