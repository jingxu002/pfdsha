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
%}
clear;clc;
load fdpe  
fp=rdfault('example.txt');
sc=rdsc('sc.txt'); % distributed displacement
[gfd,gpfd]=rdques('question.txt');
geo=[sc; fp.coor];
[cartx,carty]=geo2cart(geo(:,1),geo(:,2));
cart=[cartx,carty];
sc=cart(1:length(sc),:);
fp.coor=cart(length(sc)+1:end,:);

