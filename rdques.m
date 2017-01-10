function [gfd,gpfd]=rdques(inputfile)
% RDQUES: READ QUESTION TO PFDSHA
% Writer: JingXu   Date:2016-08-31
% Define Varaables:
%{
	inputfile		input file name, string
	gfd			    given fault displacement, unit: cm
	gpfd			given annual exceedance probability of fault displacement
%}

fid=fopen(inputfile,'rt');

if isequal(fid,-1)
	error('Input file is not exist ! ');
end

ngfd=fscanf(fid,'%g',1);
gfd=fscanf(fid,'%g',[ngfd,1]);
ngpfd=fscanf(fid,'%g',1);
gpfd=fscanf(fid,'%g',[ngpfd,1]);

fclose(fid);
