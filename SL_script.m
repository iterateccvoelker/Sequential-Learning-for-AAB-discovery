%% Alkali activated cement - active learning materials discovery with DT
clc
' Alkali activated cement - materials discovery with SL'

% This script execute Sequential Learning (SL) algorithms for materials
% discovery. It requires an input excel table with features and target
% labels. The script samples an random initial  training data set from the
% given data. The result is an output file with a data structure entitled
% "Result" in the Matlab data format *.mat. 

% Three different Machine Learning (ML) algorithms are chosen: 
% (1) Decision Trees (DT) with uncertainties from Jackknife Bootstrapping
%     (JKB)
% (2) Bagged Tree Ensembles (TE) with uncertainties from JKB
% (3) Gaussian Process Regression (GPR)
% The execution of this script repeats the SL for a set number of 
% iterations (defined by the variable "Result.Itera") and stores the
% required number of experiments for each run "ii" into the data structure
% element "Result.tries" for the respective utility function (defined by 
% the variable "strateg"). Four different utility funct. are set as
% standard, namely: MEI, MLI, MEI+D, MLI+D
% The target threshold can be as the quantile of the target property
clear;

% Import the data from excel table
Datalength=[131];    
startpoint=1;   % Datalength and startpoint can be used to control the 
                % size of the Design Space by simply selecting the lines 
                % between startpoint and Datalength
                
[~, ~, raw] = xlsread('AAC_data_Publish.xlsx');
raw = raw(4:134,3:25);
AACEdit = reshape([raw{:}],size(raw));                                     
clearvars raw;   
%% Set Parameters of the SL run
for SLMod=1:3
    for TargQ=[0.9 0.99]% The target threshold can be as the quantile of the 
                   % target property (standard 0.99 or 0.9)
for smplz=[4 8 12] % Set initial sample size
    for SampQ=[0.5]% Set sampling threshold between >0...<1 as a quantile 
                   % of the target property.
clear Result       % delete output variable in each iteration
Result.StartSamplSz=smplz;
Result.Itera=30;   % Set number of SL runs (standard=30)
Result.TargQ=TargQ; 
Result.SampQ=SampQ;
Result.FeatureSel=[1:22]; % Select features from excel file

% Feature selection and feature scaling
Features=AACEdit(:,Result.FeatureSel);
Features=Features-mean(Features,1);
Features=Features.*std(Features).^-1;
Features=Features(startpoint:Datalength,:);
Result.NoOfCandi=length(Features); 
% Labels
Labels=AACEdit(:,23);    
Labels=Labels(startpoint:Datalength,:);

% create list of initial sample candidates
SampIdx=1:size(Features,1);
SampIdx(Labels>quantile(Labels,Result.SampQ))=[]; % Remove samples with 
                                                  % Labels above the 
                                                  % sampling threshold
% Random sample initial training sets
for ii=1:Result.Itera % execute loop from 1... number of SL runs
Result.InitialSam(ii,:)=randsample(SampIdx,Result.StartSamplSz);
end
%% Start the SL 
clear trys 
for strateg=1:4 % Set utility function with strateg=1 ->MEI
                %                           strateg=2 ->MLI 
                %                           strateg=3 ->MEI+D
                %                           strateg=4 ->MLI+D
for ii=1:Result.Itera;
% Create index vector for training data (sampleIdx) and candidate data 
% (pred_idx).   
clear  sampleIdx
pred_idx=1:size(Features,1);                                               
sampleIdx=Result.InitialSam(ii,:);                                                 
pred_idx(sampleIdx)=[];  

% Create Initial Model
if SLMod==1;
[pred,predStd] = fit_DT_R_w_JK(Features,Labels,sampleIdx,pred_idx); % DT
elseif SLMod==2;
[pred,predStd] = fit_TE_R_w_JK(Features,Labels,sampleIdx,pred_idx); % TE
else SLMod==3;
[pred,predStd] = fit_GP_R_w_N(Features,Labels,sampleIdx,pred_idx,'exponential'); %GPR
end

tries=0;

%% SL iterations until success
while max(Labels(sampleIdx))<quantile(Labels,Result.TargQ);

% Update indices of training and candidate data according to strategy
if strateg==3 
if tries<15 
[sampleIdx,pred_idx] = upSaPrIDXwD(pred,predStd,pred_idx,sampleIdx,Features,strateg);  
else
[sampleIdx,pred_idx] = upSaPrIDXwD(pred,predStd,pred_idx,sampleIdx,Features,1);  
end
elseif strateg==4
if tries<15 
[sampleIdx,pred_idx] = upSaPrIDXwD(pred,predStd,pred_idx,sampleIdx,Features,strateg);  
else
[sampleIdx,pred_idx] = upSaPrIDXwD(pred,predStd,pred_idx,sampleIdx,Features,2);  
end
else
[sampleIdx,pred_idx] = upSaPrIDXwD(pred,predStd,pred_idx,sampleIdx,Features,strateg);  
end
tries=tries+1;
clear pred 

% Train model and make prediction with new data
if SLMod==1;
[pred,predStd] = fit_DT_R_w_JK(Features,Labels,sampleIdx,pred_idx); % DT
elseif SLMod==2;
[pred,predStd] = fit_TE_R_w_JK(Features,Labels,sampleIdx,pred_idx); % TE
else SLMod==3;
[pred,predStd] = fit_GP_R_w_N(Features,Labels,sampleIdx,pred_idx,'exponential'); %GPR
end

end
tries+Result.StartSamplSz
% Ratio of how many tries were necessary to how many samples are in the DS
Result.tries(strateg,ii)=(tries+Result.StartSamplSz)/(size(Features,1));                               
end 
Result.MeanTRIES(strateg)=mean(Result.tries(strateg,:))
end

if SLMod==1;
mod='DT'
elseif SLMod==2;
mod='TE'
else SLMod==3;
mod='GPR'
end
Result.model=mod;

save(['Result_',mod,...
    '_ITR_',num2str(Result.Itera),...
    '_NOC_',num2str(Result.NoOfCandi),...
    '_SAQ_',num2str(round(100*Result.SampQ)),...
    '%_TAQ_',num2str(round(100*Result.TargQ)),...
    '%_SSZ_',num2str(Result.StartSamplSz),'.mat'],'Result')

end
end
end
end
