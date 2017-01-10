#!/bin/bash
R=102/103/27/28
J=M6.5i
PS=zmh.ps

gmt set MAP_GRID_PEN_PRIMARY 0.25p,gray,2_2:1
gmt set FORMAT_GEO_MAP ddd:mm:ssF MAP_FRAME_WIDTH 3p
gmt set FONT_ANNOT_PRIMARY 7p

# 绘制中国地图
# gmt pscoast -J$J -R$R -G244/243/239 -S167/194/223 -B10f5g10 -Lg85/17.5+c17.5+w800k+f+u -K -P > $PS
# gmt psxy CN-border-La.dat -J$J -R$R -W0.5p -O -K >> $PS

gmt psbasemap -J$J -R$R -Ba  -K -P > $PS

# 绘制断层数据
gmt psxy zmh.dat -J$J -R$R -W0.5p,red -K -O >> $PS


# 绘制潜在震源区
# gawk '{print $1, $2 }' lab_loc.txt  > fix.txt
# matlab 输出的文件中，每行都有空格，需要去掉才可以用psxy
# 不然会溢出；
gmt psxy ssz_cop.txt -J$J -R$R -W0.5p,black   -O -K >> $PS
gmt pstext fix.txt -F+f6p,1,red+jCM+a0+rfirst  -J$J -R$R -O -K >> $PS



# 绘制南海区域
# R=105/123/3/24
# J=M1.1i
# gmt psbasemap -J$J -R$R -B0 -X5.4i --MAP_FRAME_TYPE=plain --MAP_FRAME_PEN=1p -K -O >> $PS
# gmt pscoast -J$J -R$R -N1/0.1p -W1/0.25p -G244/243/239 -S167/194/223 -K -O >> $PS
# gmt psxy CN-border-La.dat -J$J -R$R -W0.25p -O -K >> $PS


gmt psxy -J$J -R$R -T -O >> $PS
gmt psconvert $PS -A -Tf
rm gmt.conf gmt.history
