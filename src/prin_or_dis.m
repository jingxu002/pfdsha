function [tydis,inds]=prin_or_dis(sc,ft)
% PRIN_OR_DIS: DESIDE THE TYPE OF DISPLACEMENT ON SITE BY FAULT
% Writer: JingXu    Date: 2016-09-16      Version: 2.0
% Define Variables:
%{
	sc		site coordinate, array
	ft		fault trace, array
	tydis		type of dispalce on site by fault,logical 
    inds        index of site coordinate, then site on which fault line segments
%}
% Local variables
%{
	rs      number of site
    rf      number of fault trace points
    diff    vector of AB, point A & B is the fault trace points
    diff1   vector of AP, P is the point need to just 
    diff2   vector of BP,
    deter   the cross product of vector AP and BP, normalized by |AP|*|BP|, 
            than, the sine of angle between AP and BP
    theta   the angle between AP and BP
%}

% sc and ft must be 2 columns, 2D matrix

[rs,cs]=size(sc);
if cs~=2 && isequal(rs,2)
	sc=sc'; [rs,cs]=size(sc); %#ok<NASGU>
elseif cs~=2 && rs~=2
	error('sc must be 2 columns, 2D matrix');
end

[rf,cf]=size(ft);
if cf~=2 && isequal(rf,2)
	ft=ft'; [rf,cf]=size(ft); %#ok<NASGU>
elseif cf~=2 && rf~=2
	error('ft must be 2 columns, 2D matrix');
end


tydis=cell(rs,1);
inds=ones(rs,1);
for ii=1:rs
	for jj=2:rf %#ok<ALIGN>
        	diff=abs(ft(jj,:)-ft(jj-1,:)); ab=norm(diff);
        	diff1=ft(jj,:)-sc(ii,:);  ap=norm(diff1);
        	diff2=ft(jj-1,:)-sc(ii,:); bp=norm(diff2);
            if ap*bp==0; tydis{ii}='principal';inds(ii)=jj-1;break;end
            deter=(diff1(1)*diff2(2)-diff1(2)*diff2(1))/ap/bp;
            theta=asin(abs(deter))*180/pi;
        if theta>=1 %#ok<ALIGN>
			tydis{ii}='distributed';
			continue;
        	elseif (norm(diff1)+norm(diff2))>norm(diff)+0.05
            		tydis{ii}='distributed';
			continue;
        	else
            		tydis{ii}='principal';
                    inds(ii)=jj-1;
            		break;
        end
    end
end



