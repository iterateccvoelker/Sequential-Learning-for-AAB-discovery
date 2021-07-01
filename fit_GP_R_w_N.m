function [ pred,predStd,gprStrength_Mdl] = fit_GP_R_w_N( Features,Labels,sampleIdx,pred_idx,Kernelfnc)
% fit gaussian processes regression (GPR) model with features and labels 
% with index "sampleIdx" and make predictions for features with index 
% "pred_idx".
% 
% Parameters: 
% Features  Data
% Labels    Labels
% sampleIdx Index of training data 
% pred_idx  Index of data to predict
% 
% Input parameters: 
% Features  Data
% Labels    Labels
% sampleIdx Index of training data 
% pred_idx  Index of data to predict
% Kernelfnc Kernel function for GPR  
% 
% Output parameters:
% pred             Predicted strength
% predStd          Standard deviation of predicted strength from JKB
% gprStrength_Mdl  ML Model

gprStrength_Mdl = fitrgp(Features(sampleIdx,:),Labels(sampleIdx),'KernelFunction',Kernelfnc,'FitMethod','fic');
[pred,predStd]=predict(gprStrength_Mdl,Features(pred_idx,:));

end

