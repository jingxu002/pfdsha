% Script file: example.m
% Workflow of West Napa fault displacement example
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
    ngpfd       number of given probability, type: INT
    nsc         number of site coordinates, type: INT
%}
clear;clc;
tic;
% load fault displacement prediction equation
load fdpe  
% input fault coordinate
fp=rdfault_5th('zmh.txt'); 
sc=rdsc('sc1.txt'); 
nst=length(sc);
[gfd,gpfd]=rdques('question.txt');

geo=[sc; fp.coor];
[cartx,carty]=geo2cart(geo(:,1),geo(:,2));
cart=[cartx,carty];
sc=cart(1:length(sc),:);

fp.coor=cart(length(sc)+1:end,:);
segl=faultlength(fp.coor);
[strike, lenpp]=faultattitude(fp.coor);
acc_len=acc_len_fault(lenpp);
ngfd=length(gfd);


pgfd=zeros(ngfd,length(sc));
for jj=1:ngfd   % number of level of given fault displacements
    for ii=1:nst   % number of sites
        pgfd(jj,ii)=pfdsha_5th(sc(ii,:),fp,gfd(jj));
    end
end

ngpfd=length(gpfd);
nsc=length(sc);
fd=zeros(nsc,ngpfd);
for kk=1:nst
    for ll=1:ngpfd
        temp=interp1(log(pgfd(:,kk)),log(gfd),log(gpfd(ll)),'linear','extrap');
        fd(kk,ll)=exp(temp);
    end
end
plot3(geo(1:nsc,1),geo(1:nsc,2),fd(:,3));
xlabel('longitude'); ylabel('latitude'); zlabel('Displacement(cm)');
title('Principal displacement of APE 4E-4');

toc;
