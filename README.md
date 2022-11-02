PFDHA: A computer program used to analysis fault displacement hazard 
=====================================================================


Introduction
-------------
Fault displacement hazard problem is an essential part in the safety analysis for important infrastructures, 
like nuclear installation, oil pipeline, etc.

This package of MATLAB functions named PFDHA,
 present an updated FDPE for strike-slip fault 
based on moderate and large earthqakes in directory **fdpe**.
The updated FDPEs include two principal fault displacement models,
in the form of elliptic and quadratic, respectively.

In addition, a case study of  Zemu River fault in western China, 
is presented to demonstrate the application of PFDHA 
to a specific fault displacement hazard problem of 
strike-slip fault under segmental Possion seismicity model,
in directory **example**.
The source code in directory **src**.



Analysis Procedure
--------------------

The analysis procedure of program PFDHA include three parts:

- Functions for input and preprocessing

**rdfault_5th** read in fault parameters from input file **zmh.txt**;

**rdsc** read in the coordinates of engineering sites from input file **sc.txt**;

**rdques** read in given fault displacement values and given annual probability of exceedance need to compute from input
		file **question.txt**.
		
**geo2cart** transform geography coordinates, like the fault surface trace, to Cartesian coordinate system;

**faultattitude** compute the attitude and length of every sub-faults in fault zones;
		
- Compute engine,

**pfdsha_5th** applies the regression (quadratic) of  displacement normalized by mean value **MD**
to compute the annual probability of exceedance of given displacement on engineering sites, 
and interpolates the displacements correspond to  given APEs.
		
- Output function,

**plot_result** generate the figure of fault displacement hazard curves and 
the figure of the distribution of displacement under given APE.

Paper:
======
荆旭.走滑型断层地表永久位移预测模型研究[J].世界地震工程,2019,35(02):018-23.
[http://sjdz.paperonce.org/oa/DArticle.aspx?type=view&id=20190203]
