function dist=pd_online(a,b)
% PD_ONLINE: COMPUTE THE DISTANCE BETWEEN 2 POINTS ON THE
% SAME FAULT LINE SEGMENTS, UNIT: KM
% Writer: JingXu	Date: 2016-09-16	Version: 2.0
% Define Variables
%{
    a,b         points on a same fault line segment
    dist        distance between point a & point b
%}

dist=sqrt((a(1)-b(1))^2+(a(2)-b(2))^2);