function [xo,yo]=geo2cart(xi,yi)
% GEO2CART: TRANSFORM GEOGRAPHY COORDINATE TO CARTESIAN COORDIANTE
% Writtor: JingXu  Date: 2016-08-31
% Input:
% xi,yi     longitude and latitude, column vector
% xo,yo     coordinate in cartesian, orginate is the center of (xi,yi) unit:km
% xc,yc     origin of cartesian coordinate system

if length(xi)~= length(yi)
	error('coordinate must be in couple!');
end

if max(abs(yi))>90
	error('latitude must be less or equal to 90! ');
end

if max(abs(xi))>360
	error('longitude must be less or equal to 360');
end

xi=xi(:);  yi=yi(:); % mandatory to column vetor

% local variables
r=6371; % radious of earth, unit:km
cr=pi/180; % from degree to radians
dd=r*cr;   % length of one degree in geography

xc=mean(xi); yc=mean(yi);
xo=(xi-xc)*cos(yc*cr)*dd;
yo=(yi-yc)*dd;


