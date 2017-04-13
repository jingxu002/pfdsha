# PFDHA
probabilistic fault displacement  hazard analysis, code in Matlab.

Input module 
------------
functions of input module include as follows:

rdfault5th: read fault trace and seismicity of every segments, the structure of input file is as follows:

  line1, number of faults

  line2, number of segments of every fault

  line3, number of points in segment jj on fault ii

  line4-line3+np, coordinate of points (longitude, latitude)

  lin4+np, number of maximum magnitude


