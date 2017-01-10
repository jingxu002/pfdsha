function [strike,length]=faultattitude(coor)
% FAULT ATTITUDE: COMPUTE ATTITUDE OF STRIKE SLIP FAULT
% Writer: JingXu    Date: 2016-09-13   Version: 1.0
% Define Variables:
%{
	coor		coordinate of fault segment, unit: km
	strike		strike of fault segment, unit: degree from east, anti-clockwise
	length		length of fault segment, unit: km
%}
% Local Variables:
%{
	nr,nc		number of rows and columns of coordinate	
	ii		subscript of array length and strike
	tx,ty		temp coordiante of vector P(ii)P(ii-1)
	length		length of vector P(ii)P(ii-1), unit: km
	cs,ss		cosine and sine of strike

%}

[nr,nc]=size(coor);
if nr~=2 && nc~=2
	error(' coordinate must be a 2 columns 2D matrix ! ');
elseif nr==2 && nc~=2
	coor=coor';
end


[nr,nc]=size(coor);
coor=sortrows(coor,1);
length=zeros(nr-1,1);
strike=zeros(nr-1,1);

for ii=2:nr
	tx=coor(ii,1)-coor(ii-1,1);
	ty=coor(ii,2)-coor(ii-1,2);
	lengtht=sqrt(tx^2+ty^2);
	cs=tx/lengtht; ss=ty/lengtht;

	length(ii-1)=lengtht;
	if ss>=0
		striket=acos(cs)*180/pi;
	elseif cs>=0
		striket=asin(ss)*180/pi+360;
	else
		striket=asin(-ss)*180/pi+180;
	end
	strike(ii-1)=striket;
end
