function [ pred,predStd,TEStrength_Mdl] = fit_TE_R_w_JK( Features,Labels,sampleIdx,pred_idx)
% Fit a bagged decision tree model with uncertainty estimates from jackknife 
% bootstrapping with features and labels with index "sampleIdx" and make 
% predictions for features with index "pred_idx"
% 
% Input parameters: 
% Features  Data
% Labels    Labels
% sampleIdx Index of training data 
% pred_idx  Index of data to predict
% 
% Output parameters:
% pred             Predicted strength
% predStd          Standard deviation of predicted strength from JKB
% TEStrength_Mdl   ML Model

Traindat=JKBoot(Features(sampleIdx,:));
Tranlabs=JKBoot(Labels(sampleIdx,:));
for ii=1:size(Traindat,3)
t = templateTree('Surrogate','on');  
TEStrength_Mdl = fitrensemble(Traindat(:,:,ii),Tranlabs(:,:,ii),'Learners',t,'NumLearningCycles',10);
pred_(:,ii)=predict(TEStrength_Mdl,Features(pred_idx,:));
end
t = templateTree('Surrogate','on');
TEStrength_Mdl = fitrensemble(Features(sampleIdx,:),Labels(sampleIdx,:),'Learners',t,'NumLearningCycles',10);
pred=mean(pred_,2);
predStd=std(pred_,0,2);
end

