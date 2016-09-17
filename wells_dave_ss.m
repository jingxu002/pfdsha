function dave=wells_dave_ss(m)
% WELLS_DAVE_SS: COMPUTE AVERAGE DISPLACEMENT OF FAULT DISPLACEMENT OF STRIKE SLIP FAULT, UNIT: CM
% Writer: JingXu	Date: 2016-09-16      Version: 1.0
% Define Variables
%{
	m		magnitude, unit: Mw
	dave		average displace of strike slip fault, unit: cm
%}

dave=100*10^(-6.32+0.9*m);
