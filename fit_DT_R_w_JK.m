function [ pred,predStd,DTStrength_Mdl] = fit_DT_R_w_JK( Features,Labels,sampleIdx,pred_idx)
% Fit a decision tree model with uncertainty estimates from jackknife 
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
% DTStrength_Mdl   ML Model

Traindat=JKBoot(Features(sampleIdx,:));
Trainlabs=JKBoot(Labels(sampleIdx,:));
for ii=1:size(Traindat,3)
DTStrength_Mdl = fitrtree(Traindat(:,:,ii),Trainlabs(:,:,ii),'Surrogate','on');
pred_(:,ii)=predict(DTStrength_Mdl,Features(pred_idx,:));
end
t = templateTree('Surrogate','on');
DTStrength_Mdl = fitrensemble(Features(sampleIdx,:),Labels(sampleIdx,:),'Learners',t);
pred=mean(pred_,2);
predStd=std(pred_,0,2);
end

