function [cf_,gof]=fit_xl_logddave(com_xl,log_com_ddave)
% FIT_XL_LOGDDAVE: FIT QUADRATIC  REGRESSION OF XL AND LOG(D/DAVE)  
%   AND PLOT FIGURE OF DATA AND REGRESSION EQUATION

%   Creates a plot, similar to the plot in the main curve fitting window, 
%   using the data that you provide as input.  
%   You can apply this function to the same data you used with cftool
%   or with different data.  
%   You may want to edit the function to customize the code and this help message.



% Data from dataset "log_com_ddave vs. com_xl":
%    X = com_xl
%    Y = log_com_ddave
%    Unweighted
% Modified by JingXu, at 2017/07/25



% Set up figure to receive datasets and fits
f_ = clf;
figure(f_);
set(f_,'paperunits','centimeters',...
    'papertype','A4','paperposition',[3.5 4.5 14 14]);
legh_ = []; legt_ = {};   % handles and text for legend
xlim_ = [Inf -Inf];       % limits of x axis
ax_ = axes;
set(ax_, 'Units','normalized','OuterPosition',[0 0 1 1]);
set(ax_,'Box','on');

hold on;


% --- Plot data originally in dataset "log_com_ddave vs. com_xl"
com_xl = com_xl(:);
log_com_ddave = log_com_ddave(:);
% h_, handal of component in figure
h_ = line(com_xl,log_com_ddave,'Parent',ax_,'Color',[0.333333 0 0.666667],...
    'LineStyle','none', 'LineWidth',2,...
    'Marker','.', 'MarkerSize',6);
xlim_(1) = min(xlim_(1),min(com_xl));
xlim_(2) = max(xlim_(2),max(com_xl));
legh_(end+1) = h_;
legt_{end+1} = 'log(D/D_{ave}) vs. l/L';

% Nudge axis limits beyond data limits
if all(isfinite(xlim_))
    xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
    set(ax_,'XLim',xlim_)
else
    set(ax_, 'XLim',[-0.0049959595959595962, 0.50459191919191915]);
end


% Create fit
ok_ = isfinite(com_xl) & isfinite(log_com_ddave);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs', ...
        'Ignoring NaNs and Infs in data' );
end
ft_ = fittype('poly2');

% Fit this model using new data
[cf_ , gof ]= fit(com_xl(ok_),log_com_ddave(ok_),ft_);

% Or use coefficients from the original fit:
if 0
    cv_ = { -20, 18, -4};
    cf_ = cfit(ft_,cv_{:});
end


% Plot this fit and confidence interval, one sigma
h_ = plot(cf_,'predobs',2*cdf('normal',1,0,1)-1);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_(1);
legt_{end+1} = 'FDPE';
legh_(end+1) = h_(2);
legt_{end+1} = 'Confidence interval';

% Plot this fit and confidence interval, two sigma
h_ = plot(cf_,'predobs',2*cdf('normal',2,0,1)-1);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);

% Plot this fit and confidence interval, three sigma
h_ = plot(cf_,'predobs',2*cdf('normal',3,0,1)-1);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);

% Done plotting data and fits.  Now finish up loose ends.
leginfo_ = {'Orientation', 'vertical', 'Location', 'SouthEast'};
h_ = legend(ax_,legh_,legt_,leginfo_{:});  % create legend
set(h_,'Interpreter','none');
xlabel(ax_,'');               % remove x label
ylabel(ax_,'');               % remove y label
hold off;
