# Sequential-Learning-for-AAB-discovery with Matlab

## Description and requirements
This script runs Sequential Learning (SL) algorithms for materials discovery. To execute simply download all files in the same file directory and execute 'SL_script.m' with matlab. This script has been created on Matlab Version: 9.9.0.1592791 (R2020b) Update 5. It requires the Statistics and Machine Learning Toolbox (Version 12.0). Older versions may be supported. 

## Purpose
The purpose of this code is to make the results described in the work entitled "Sequential learning to accelerate discovery of alkali-activated binders" reproducible. Therefore, the underlying data is provided, too (AAC_data_Publish.xlsx). The script can be applied to other datasets if the data import is adjusted accordingly. 

To determine the performance of SL methods, it is common to use simulated experiments where the ground truth labels for all data points are already known. Initially, only a small fraction is provided to the SL algorithm (although more training data would be available). This is extended with one new data point from the remainder of the available data at each iteration. It is investigated which approach requires the least amount of data to achieve the goal. Approaches that require less data simply lead to faster success in laboratory practice. Thus, the goal is not to actually discover new materials using all available data, but to validate material discovery methods for scenarios where fewer labels are known (e.g., for new materials).

## Content
The code requires an Excel input table containing features and target labels (as is specified in the import section at begining of the script). The script samples  random initial training data sets from the given data.The execution of this script repeats the SL for a specified number of iterations (defined by the variable "Result.Itera") and stores the required number of experiments for each run "ii" in the data structure element "Result.Tries" for the respective utility function (defined by the variable "strateg"). By default, four different utility functions are set, namely: MEI, MLI, MEI+D, MLI+D. The target threshold can be as quantile of the target property. 

 Three different machine learning (ML) algorithms can be selected: 
(1) Decision Trees (DT) with uncertainties from Jackknife Bootstrapping (JKB).
(2) Bagged Tree Ensembles (TE) with uncertainties from JKB.
(3) Gaussian Process Regression (GPR)

## Result
The output is an result file with a data structure called "result" in the Matlab data format *.mat. 

