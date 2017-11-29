function acc_len=acc_len_fault(lenpp)
% ACC_LEN_FAULT: ACCUMULATION OF FAULT LINE SEGMENT'S LENGTH, UNIT: KM
% Writer: JingXu 	Date: 2016-09-14	Version: 1.0
% Define Variables:
%{
	lenpp		length of fault line segments， unit: km
	acc_len		accumulation of fault line segment's length, unit: km
%}
% Local Variables:
%{
	nl		number of fault line segments, type: INT
%}

nl=length(lenpp); 
acc_len=zeros(nl,1);
for ii=1:nl
  acc_len(ii)=sum(lenpp(1:ii));
end


