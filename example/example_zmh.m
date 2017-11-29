% Script file: example_zmh.m
% Workflow of the case study on  Zemu River fault displacement hazard  
% Writer: JingXu  Date: 2016-09-11   Version: 1.0
% Define variables:
%{
    fdpe		parameters of fault displacement(unit:cm) predictive equation
    fp 		    coordinate & seismicy of fault segment, structure variable
                need to express the pattern of coordinate, liek the direction, length, etc.
    sc			site coordinate, unit: km
    gfd,gpfd		given fault displacemet, unit: cm; given probability of fault displacement
    geo         geography coordinate, logitude & latitude, degrees
    cart        cartesine coordinate, unit: km
    fd          fault displacement of given annual probability, unit: cm
    NGPFD       number of given probability, type: INT
    nsc         number of site coordinates, type: INT
%}
dbstop if error


clear;clc;
% Start stopwatch timer
tic;
addpath ../src

 
% input fault trace coordinate
fp=rdfault_5th('zmh.txt'); 

% input site coordinate
sc=rdsc('sc.txt'); 
NST=length(sc);

% input of given fault displacement, unit: cm
% and given annual probability of exceedance
[gfd,gpfd]=rdques('question.txt');
NGFD=length(gfd);
NGPFD=length(gpfd);

geo=[sc; fp.coor];
[cartx,carty]=geo2cart(geo(:,1),geo(:,2));
cart=[cartx,carty];
sc=cart(1:NST,:);

fp.coor=cart(NST+1:end,:);
segl=faultlength(fp.coor);
[strike, lenpp]=faultattitude(fp.coor);
acc_len=acc_len_fault(lenpp);

save('fault_parameters', 'fp');

pgfd=zeros(NGFD,NST);
for jj=1:NGFD   % number of level of given fault displacements
    for ii=1:NST   % number of sites
        pgfd(jj,ii) = pfdsha_5th(sc(ii,:), gfd(jj));
    end
end


fd=zeros(NST,NGPFD);
for kk=1:NST
    for ll=1:NGPFD
        temp=interp1(log(pgfd(:,kk)), log(gfd), log(gpfd(ll)), 'linear', 'extrap');
        fd(kk,ll)=exp(temp);
    end
end

save('result');
%% plot results
plot_result

%% print the results, con_APE and hazard curves to .eps files
print_result
% read elapsed time from stopwatch 
toc;
