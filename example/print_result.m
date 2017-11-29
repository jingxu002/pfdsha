% script file: print_result.m
% PRINT_RESULT: PRINT THE FAULT DISPLACEMENT (CM) OF ALL SITES
% UNDER GEVEN APE AND THE HAZARD CURVES
% Writer: JingXu   Date: 2017/11/24 

dbstop if error
clear;clc;
close all

openfig('fd_conAPE.fig');
print -deps -r300 fd_conAPE.eps
close 

openfig('fd_hazard_curves.fig');
print -depsc -r300 fd_haz_cur.eps
close 