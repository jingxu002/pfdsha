#!/bin/bash
R=102/103/26.9/28
J=M13c
PS=zmh_multi.ps


# plot basemap
gmt psbasemap -J$J -R$R -Bxa0.2 -Bya0.2  -P -K  -V > $PS
# 添加图例
gmt pslegend -R$R -J$J -Dg102.1/27.2+w2i+l2 -F+g229+p0.25p -O -K  -V >> $PS << EOF
G 0.01i
C black 
D 0.5i 2p,black 
T The Surface Trace of 
T Sub-faults of Zemu River Fault Zone
EOF
# 绘制断层数据
# gmt psxy CN-faults.dat -J$J -R$R -W0.5p,red -K -O >> $PS
# 绘制则木河断裂
gmt psxy zmh_multi.dat -J$J -R$R -Sqn1:+Lh  -Wthick -O -V >> $PS
# gmt psxy zmh.dat -J$J -R$R -St0.1i,blue  -K -O >> $PS
# gmt psxy zmh.dat -J$J -R$R -Sc0.05i  -Gblue  -O -V >> $PS




# END

# Convert to .eps
gmt psconvert $PS -A -Te

# remove temple files
rm gmt.* cutTopo*.grd colorTopo.cpt tmp*
