function coor=dis2coor(dis,fault)
% DIS2COOR: TRANSFORM FROM DISTANCE ON FAULT TRACE TO CARTESIAN COORDINATE, UNIT: KM
% Writer: JingXu 	Date: 2016-09-14    Version: 1.0
% Define Variables
%{
	dis		distance from fault edge vertex, unit: km
	fault		cartesian coordiante of fault trace, unit: km
	coor 		cartesian coordinate of point which distance to edge vertex is dis, unit: km
%}
% Local Variables
%{
	nr,nc		number of rows and columns of 2D matrix fault, type: INT
	strike		strike of fault line segments, anti-clock wise degrees from EAST
	lenpp		length of fault line segments, unit: km
	inds		index of fault line segment start the distance of dis
	acc_len		accumulation of fault line segments, unit: km
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
  nr=nc;
end

[strike, lenpp]=faultattitude(fault);
acc_len=acc_len_fault(lenpp);
inds=find(acc_len<dis,1,'last')+1;
coor=ones(1,2);
coor(1)=fault(inds,1)+(dis-acc_len(inds-1))*cos(strike(inds)*pi/180);
coor(2)=fault(inds,2)+(dis-acc_len(inds-1))*sin(strike(inds)*pi/180);



