% scripe file: test_coor.m
coor=zeros(45,2);
for jj=1:45
dis=jj;
coor(jj,:)=dis2coor(dis,fp.coor);
end

[tydis,inds]=prin_or_dis(coor,fp.coor);