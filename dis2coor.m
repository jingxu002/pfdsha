function [coor,inds]=dis2coor(dis,fault,strike,acc_len)
% DIS2COOR: TRANSFORM FROM DISTANCE ON FAULT TRACE TO CARTESIAN COORDINATE, UNIT: KM
% Writer: JingXu 	Date: 2016-09-14    Version: 1.0
% Define Variables
%{
	dis		distance from fault edge vertex, unit: km
	fault		cartesian coordiante of fault trace, unit: km
	coor 		cartesian coordinate of point which distance to edge vertex is dis, unit: km
    inds        coor on which fault line segment 
    strike		strike of fault line segments, anti-clock wise degrees from EAST
    acc_len		accumulation of fault line segments, unit: km
%}
% Local Variables
%{
	nr,nc		number of rows and columns of 2D matrix fault, type: INT
    np          number of points on fault trace, type: INT
	lenpp		length of fault line segments, unit: km
	inds		index of fault line segment start the distance of dis
	
%}
%Algorithm
%{
	Find the coor on which fault line segment (inds), then compute the length (dis-acc_len(inds-1)),
	multiple the cosine and sine of strike
%}

[nr,nc]=size(fault);
if nr~=2 && nc~=2
  error('Fault must be a 2 columns 2D matrix !');
elseif nr==2 && nc~=2
  fault=fault';
end
np=nr;

% [strike, lenpp]=faultattitude(fault);
% acc_len=acc_len_fault(lenpp);
if dis<=acc_len(1)
  coor=fault(1,:)+dis*[cos(strike(1)),sin(strike(1))];
  inds=1;
elseif dis>=acc_len(np-1)
    inds=np;
    coor=fault(np,:)+(dis-acc_len(np-1))*[cos(strike(np-1)),sin(strike(np-1))];
else
    inds=find(acc_len<dis,1,'last')+1;
    % coor(1)=fault(inds,1)+(dis-acc_len(inds-1))*cos(strike(inds)*pi/180);
    % coor(2)=fault(inds,2)+(dis-acc_len(inds-1))*sin(strike(inds)*pi/180);
    coor=fault(inds,:)+(dis-acc_len(inds-1))*[cos(strike(inds)),sin(strike(inds))];
end



