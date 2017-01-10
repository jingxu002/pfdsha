% Script file: plot_ssz.m
% PLOT_SSZ: PLOT SEISMIC SOURCE ZONES BY GMT
% Writter: Jing Xu   Date: 2017/01/10   Version: 1.0


clear;clc;

load  seismicity_parameter   sszp

nssz=length(sszp);
fid=fopen('ssz_cop.txt','wt');
fid1=fopen('lab_loc.txt','wt');

for ii=1:nssz
    temp= sszp(ii).cop;
    fprintf(fid,'>  %d  \n', ii);
    fprintf(fid, ' %g  %g \n ', temp');
    fprintf(fid1,' %g %g %d \n', mean(temp), ii);
end

fclose('all');