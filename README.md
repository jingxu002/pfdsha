# pfdsha
probabilistic fault displacement seismic hazard analysis, code in Matlab
rdfault: read fault trace and seismicity of every segments, the structure of input file is as follows:
number of faults
number of segments of every fault
number of points in segment jj on fault ii
coordinate of points (longitude, latitude)
number of maximum magnitude
mu1 p1 ... mun pn
minmum magnitude, annual frequency of earthquake which magnitude is larger than m0, parameter value of \beta in G-R relationship
m0, vm0, beta
