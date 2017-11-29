function fault_para=rdfault_5th(inputfile)
% RDFAULT: READ PARAMETERS OF FAULT
% Writtor: JingXu  Date: 2017-01-10  Version: 2.0
% Define Variables:
%{
	inputfile               input file name, string 
	nft                     number of fault
	nseg                    number of segment of fault
    frac                    fraction of seismicity  of seismic source zone attribute to fault

	m0                      minimum magnitude in compute
    mu                      maximum magnitude in earthquake statistic belt
	vm0                     annual frequency of earthquake whose magnitude is lager then m0
	beta                    coefficient in G-R relationship

    nmi                     number of magnitude interval
	mag1,...                start of magnitude interval
    sf1,...                 spatial function of seismic source zone
	v1,...                  annual number of earthquakes in magnitude interval 
   

	fault_para              a structure variable of output
	sumseg                  total number of fault segments
%}


% deside whether the input file is exist
fid=fopen(inputfile);
if isequal(fid,-1)
	error('Input file is not exist! ');
end


title=fgetl(fid); %#ok<NASGU>
nft=fscanf(fid,'%g',[1 1]);
nseg=fscanf(fid,'%g',[1 nft]);
fp=struct('coor',{},'seis',{}); % different segment of fault have different parameters
% structure variable have 2 fields, coordinate and seismicity
sumseg=sum(nseg); %#ok<NASGU>
% fp.coor=cell(sumseg,1);
% fp.seis=cell(sumseg,1);
for ii=1:nft
	for jj=1:nseg(ii)
		ncoor=fscanf(fid,'%g',[1 1]); % number of point in segment(jj) of fault ii
		nele=sum(nseg(1:ii-1))+jj; % number of elements 
        temp=fscanf(fid,'%g',[2 ncoor]);
        fp(nele).coor=temp';
        nmi=fscanf(fid,'%d', [1 1]);
        f_belt=fscanf(fid,'%g',[1 4]);
        mag=fscanf(fid,'%g', [1 nmi]);
        sdf=fscanf(fid,'%g', [1 nmi]);
		frac=fscanf(fid,'%g',[1 nmi]);       
        fp(nele).seis=[nmi,f_belt,mag,sdf,frac];
 
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

frac   % fraction of seismicity  of seismic source zone attribute to fault 
m0,mu,vm0,beta
nmi
mag1,mag2,...magnmi
sf1,sf2,...sfnmi
%}
