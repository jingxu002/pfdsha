function segl=faultlength(coor)
% FAULTLENGTH: LENGTH OF FAULT SEGMENT, UNIT: KM
% Writer: JingXu 	Date: 2016-09-07	Version: 1.0
% Define variables:
%{
	coor		the coordinate of fault segment, unit: km
	segl		length of fault segment, unit: km
%}
% local variables:
%{
	nr,nc		number of rows and columns of coordinate
	np		number of points in fault segment
%}
% Algorithm
%{
	sort x coordiante in ascending, compute the distance between neabor points,
	then summary togather
	There will be a problem, when the fault length near a circle, but,
	in the actual questions, fault segments near lines,
%}

[nr,nc]=size(coor);
if nc~=2 && nr==2
	coor=coor';
elseif nc~=2 && nr~=2
	error(' The coordinate must be 2 columns 2D matrix! ');
end

coor=sortrows(coor,1); 
np=length(coor);
segl=0;
for ic=2:np
	segl=segl+sqrt((coor(ic,1)-coor(ic-1,1))^2+(coor(ic,2)-coor(ic-1,2))^2);
end
