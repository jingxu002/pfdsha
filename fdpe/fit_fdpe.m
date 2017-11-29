% Script file: fit_fdpe.m
% FIT_FDPE: FITTING NEW FAULT DISPLACEMENT PREDICTION EQUATION
% Writer: JingXu   Date: 2016-09-12    Version: 1.0

% ========================================
% Modified: Jing Xu  Date: 2017-11-21  
% added the fault displacement data and surface rupture of
% 2014 Ms7.3 Yutian Earthquake & 2011 Ms7.1 Yushu Earthquake
% ======================================== 
% xl and log(ddave) follow quadratic relationship, than, 
% log(ddave)=a*xl^2+b*xl+c+epsilon*sigma, sigma is the RSME in curvefitting
% toolbox
% Define Variables:
%{
    xl      ratio between distance from site to vertex and surface rupture length
    ddave   ratio between observed displacement and average displacement
%}

clear;clc;
dbstop if error

%% The coefficient of Wells and Coppersmith (1994) 
% used to calculate the average on-fault displacment, Dave
a = -6.32; b = 0.90;
%% load and transform surface rupture data of Yushu and Yutian
load yushu
xl_ysh = l; M_ysh = 7.1;
dave_ysh = 100 * 10^(a + b * M_ysh);
ddave_ysh = d ./ dave_ysh;
log_ddave_ysh = log(ddave_ysh);
load yutian
xl_yt = l; M_yt = 7.3;
dave_yt = 100 * 10^(a + b *M_yt);
ddave_yt = d ./ dave_yt;
log_ddave_yt = log(ddave_yt);
%% Data of combined data from Petersen et al. 2011
composite=xlsread('PFDHA_Displacements.xls','Combined data','a5:c1137');
xl_o=composite(:,1);
log_ddave_o=log(composite(:,3));

%% Surface rupture data from Napa earthquake,
napa_prin=load('napa_prin.txt');
xl=napa_prin(:,2)/max(napa_prin(:,2));
xl_n =min(xl,1-xl);
ddave_n =napa_prin(:,1)/mean(napa_prin(:,1));
log_ddave_n = log(ddave_n);
%% composite data base
com_xl=[composite(:,1); xl_n; xl_ysh; xl_yt];
com_log_ddave=log([composite(:,3); ddave_n; ddave_ysh; ddave_yt]);

%% fit curves
[cf_, gof]=fit_fdpe_elli(com_xl,com_log_ddave);

