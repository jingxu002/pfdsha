function sc=rdsc(inputfile)
% RDSC: READ SITE COORDINATE
% Writer: JingXu   Date: 2016-08-31  Version: 1.0
% Define variable:
%{
	inputfile		input file, string
	sc			site coordinate, 2 columns
%}

fid=fopen(inputfile,'rt');
if isequal(fid,-1)
	error(' Input file is not exist !');
end

scty=fscanf(fid,'%g',1); % type of site coordinate, 1 point by pint; 2, xo,yo,dx,dy,nx,ny
switch scty
	case 1
		nsc=fscanf(fid,'%g',1);
		sc=fscanf(fid,'%g',[2,nsc]);
		sc=sc';
	case 2
		tem=fscanf(fid,'%g',[6,1]);
		[xo,yo,dx,dy,nx,ny]=deal(tem(1),tem(2),tem(3),tem(4),tem(5),tem(6));
		x=xo+(1:nx)'*dx;
		y=yo+(1:ny)'*dy;
		[x1,y1]=meshgrid(x,y);
		sc(:,1)=reshape(x1,nx*ny,1);
		sc(:,2)=reshape(y1,nx*ny,1);
	end

fclose(fid);
