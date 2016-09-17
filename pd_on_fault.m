function pd=pd_on_fault(p1,p2,fault,lenpp)
% PD_ON_FAULT: DISTANCE BETWEEN POINTS ON FAULT TRACE, UNIT: KM
% Writer: JingXu	Date: 2016-09-16	Version: 2.0
% Define Variables:
%{
	p1,p2		points on fault trace, coordinate unit: km
	fault		coordinate of fault trace, unit: km
    lenpp       length of fault line segments, unit: km
	pd		distance between point p1 and point p2, unit: km
%}
% Local Variables:
%{
	p           composite matrix of point p1 and p2
    tydis       points whether on fault trace
    inds        point on which fault line segments
    nr,nc		number of rows and columns of coordinate of fault trace
    strike      strike angle of fault line segments, degrees of anti-cloce wise from EAST
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

p=[p1;p2];
[tydis,inds]=prin_or_dis(p,fault);
if strcmp(tydis{1},'distributed')==1 ||  strcmp(tydis{2},'distributed')==1
  error(' Points must be on the fault trace ! ');
end

% [strike,lenpp]=faultattitude(fault);

if inds(2)-inds(1)>=2
    pd1=pd_online(p1,fault(inds(1)+1,:));
    pd2=pd_online(p2,fault(inds(2),:));
    pdw=sum(lenpp(inds(1)+1:inds(2)-1));
    pd=pd1+pd2+pdw;
elseif inds(1)-inds(2)>=2
    pd2=pd_online(p2,fault(inds(2)+1,:));
    pd1=pd_online(p1,fault(inds(1),:));
    pdw=sum(lenpp(inds(2)+1:inds(1)-1));
    pd=pd1+pd2+pdw;
elseif inds(1)==inds(2)
    pd=pd_online(p1,p2);
elseif inds(2)-inds(1)==1
    pd1=pd_online(p1,fault(inds(1)+1,:));
    pd2=pd_online(p2,fault(inds(2),:));
    pd=pd1+pd2;
else
    pd1=pd_online(p1,fault(inds(1),:));
    pd2=pd_online(p2,fault(inds(2)+1,:));
    pd=pd1+pd2;
end


