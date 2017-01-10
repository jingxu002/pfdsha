% Script file: fit_fdpe.m
% FIT_FDPE: FITTING NEW FAULT DISPLACEMENT PREDICTION EQUATION
% xl and log(ddave) follow quadratic relationship, than, 
% log(ddave)=a*xl^2+b*xl+c+epsilon*sigma, sigma is the RSME in curvefitting
% toolbox
% Define Variables:
%{
    xl      ratio between distance from site to vertex and surface rupture length
    ddave   ratio between observed displacement and average displacement
%}
clear;clc;
%% Data of combined data from Petersen et al. 2011
composite=xlsread('PFDHA_Displacements.xls','Combined data','a5:c1137');
xl_o=composite(:,1);
log_ddave_o=log(composite(:,3));
%{
 
%}
[cf_, gof]=fit_xl_logddave(xl_o,log_ddave_o);
 [ao,bo,co,sigmao]=deal(cf_.p1,cf_.p2,cf_.p3,gof.rmse);
%% Surface rupture data from Napa earthquake,
napa_prin=load('napa_prin.txt');
xl=napa_prin(:,2)/max(napa_prin(:,2));
xl=min(xl,1-xl);
ddave=napa_prin(:,1)/mean(napa_prin(:,1));
%{
 
%}
[cf_, gof]=fit_xl_logddave(xl,log(ddave));
 [an,bn,cn,sigman]=deal(cf_.p1,cf_.p2,cf_.p3,gof.rmse);
%% composite data base
com_xl=[composite(:,1);xl];
com_log_ddave=log([composite(:,3); ddave]);
%{
 
%}
[cf_, gof]=fit_xl_logddave(com_xl,com_log_ddave);
[ac,bc,cc,sigmac]=deal(cf_.p1,cf_.p2,cf_.p3,gof.rmse);