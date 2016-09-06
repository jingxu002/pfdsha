function srl=wells_ss(m,ep)
% WELLS_SS: COMPUTE SURFACE RUPTURE LENGTH OF STRIKE SLIP FAULT BY WELLS & COMMPERSMITH, 1994
% Writer: JingXu   Date: 2016-09-06  Version: 1.0
% Define Variables:
%{
	m		magnitude, unit: Mw
	ep		\epsilon, random variable follows standard normal distribution
	srl		surface rupture length, unit: km
%}
% local variables:
%{
	a,b		coefficients in srl predict equation
	sigma		standard deviation srl predict equation
%}
a=-3.55; b=0.74; sigma=0.23;
srl=10^(a+b*m+ep*sigma);
