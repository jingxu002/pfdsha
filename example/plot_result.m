% script file: plot_result.m
%  PLOT_RESULT: PLOT THE RESULTS OF CASE STUDY OF ZEMU RIVER FAULT
% Writer: JingXu   Date: 2017/11/24  

clear;clc;
close all
dbstop if error

%% load fault hazard analysis results
load result
%% plot fault displacement for given APE
fig1 = figure(1);
fig1.Units = 'centimeters';
fig1.Position = [0 0 14 14];
% ax1 is the son of fig1
ax1 = axes('Parent', fig1);
ax1.Units = 'centimeters';
ax1.Position = [2 2 10 10];
plot3(ax1, geo(1:NST,1),geo(1:NST,2),fd(:,4),'k-o');
xlabel('longitude'); ylabel('latitude'); zlabel('Displacement(cm)');
title('Principal displacements of all sites for the given APE 1E-4');
savefig(fig1, 'fd_conAPE.fig')

%% plot fault displacement hazard curves for all sites
fig2 = figure(2);
fig2.Units = 'centimeters';
fig2.Position = [0 0 14 14];
% ax2 is the son of fig2
ax2 = axes('Parent', fig2);
ax2.Units = 'centimeters';
ax2.Position = [2 2 10 10];
ax2.XLim = [-1, 3];
ax2.YLim = [-12, -2];
nmp = ceil(NST / 2);
for ii = 1:NST
    tmpx = log10(gfd); 
    tmpy = log10(pgfd(:, ii));
    plot(ax2, tmpx, tmpy, 'color', rand([1 3]), ...
        'linewidth', 1);
    hold on
end
grid on;
ax2.XLim = [-1, 3];
ax2.YLim = [-12, -2];
xlabel('Log_{10} (Fault displacement)'); 
ylabel('Log_{10} (Annual probability of exceedance)');
title('Fault displacement hazard curve for all sites');
savefig(fig2, 'fd_hazard_curves.fig')
hold off;