function [tydis]=prin_or_dis(sc,ft)
% PRIN_OR_DIS: DESIDE THE TYPE OF DISPLACEMENT ON SITE BY FAULT
% Writer: JingXu    Date: 2016-09-02      Version: 1.0
% Define Variables:
%{
	sc		site coordinate, array
	ft		fault trace, array
	tydis		type of dispalce on site by fault,logical 
%}


% sc and ft must be 2 columns, 2D matrix

[rs,cs]=size(sc);
if cs~=2 && isequal(rs,2)
	sc=sc'; [rs,cs]=size(sc);
elseif cs~=2 && rs~=2
	error('sc must be 2 columns, 2D matrix');
end

[rf,cf]=size(ft);
if cf~=2 && isequal(rf,2)
	ft=ft'; [rf,cf]=size(ft);
elseif cf~=2 && rf~=2
	error('ft must be 2 columns, 2D matrix');
end


tydis=cell(rs,1);

for ii=1:rs
	for jj=2:rf
        diff=abs(ft(jj,:)-ft(jj-1,:));
        diff1=ft(jj,:)-sc(ii,:);
        diff2=ft(jj-1,:)-sc(ii,:);
		deter=det([diff1;diff2]);
		if deter~=0
			tydis{ii}='distributed';
			continue;
        elseif (abs(diff1)+abs(diff2))>diff
            tydis{ii}='distributed';
			continue;
        else
            tydis{ii}='principal';
            break;
		end
	end
end



