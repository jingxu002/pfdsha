function fault_para=rdfault(inputfile)
% RDFAULT: READ PARAMETERS OF FAULT
% Writtor: JingXu  Date: 2016-08-31  Version: 1.0
% Define Variables:
%{
	inputfile               input file name, string 
	nft                     number of fault
	nseg                    number of segment of fault
	mu                      maximum magnitude of fault
	p                       probability of mu
	m0			minimum magnitude in compute
	fm0 			annual frequency of earthquake whose magnitude is lager then m0
	beta 			coefficient in G-R relationship
	fault_para 		a structure variable of output
	sumseg			total number of fault segments
%}


% deside whether the input file is exist
fid=fopen(inputfile);
if isequal(fid,-1)
	error('Input file is not exist! ');
end


title=fgetl(fid);
nft=fscanf(fid,'%g',[1 1]);
nseg=fscanf(fid,'%g',[1 nft]);
fp=struct('coor',{},'seis',{}); % different segment of fault have different parameters
% structure variable have 2 fields, coordinate and seismicity
sumseg=sum(nseg);
% fp.coor=cell(sumseg,1);
% fp.seis=cell(sumseg,1);
for ii=1:nft
	for jj=1:nseg(ii)
		ncoor=fscanf(fid,'%g',[1 1]); % number of point in segment(jj) of fault ii
		nele=sum(nseg(1:ii-1))+jj; % number of elements 
        temp=fscanf(fid,'%g',[2 ncoor]);
        fp(nele).coor=temp';
		nmu=fscanf(fid,'%g',[1 1]); % number of maximum magnitude
		fp(nele).seis=fscanf(fid,'%g',2*nmu+3);
	end
end
fclose(fid);


fault_para=fp;

%{
data structure of fault parameter:
nfault
nsegment
ncoordinate of segment jj in fault ii
coordinate (longitude,latitude)
nmu
mu1,p1,... mun,pn
m0,vm0,beta
%}
