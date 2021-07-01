function [ New_sampleIdx,New_pred_idx] = upSaPrIDXwD( pred, predStd, pred_idx, sampleIdx, Features,Strategy)
% This function updates the  sampling- and prediction-index according to a 
% selected strategy
% pred              Predictions
% predStd           Standard deviation of prediction
% Strategy          Strategy for candidate selcetion 
%                       1=MEI
%                       2=MLI
%                       3=MU
% sampleIdx         Index of selected training data 
% predIdx           Index of data to make predictions on
% TotalNoOfSamples  This is typically: length(Features)


[~,MEI_IDX]=max(pred);
[~,MLI_IDX]=max(pred+1.96*predStd);
[~,MU_IDX]=max(predStd);

for ii= 1:length(pred_idx)
Distance(ii)=min(sqrt(sum((Features(sampleIdx,:)-Features(pred_idx(ii),:)).^2,2)));
end
[~,Didx]=max(Distance(pred>=quantile(pred,0.95)));
[~,LDidx]=max(Distance((pred+1.96*predStd)>=quantile((pred+1.96*predStd),0.95)));

if Strategy==1;  
  sampleIdx(end+1)=pred_idx(MEI_IDX);
elseif Strategy==2;
  sampleIdx(end+1)=pred_idx(MLI_IDX);
% elseif Strategy==3;
%   sampleIdx(end+1)=pred_idx(MU_IDX);
elseif Strategy==3;
sampleIdx(end+1)=pred_idx(Didx);
elseif Strategy==4;
sampleIdx(end+1)=pred_idx(LDidx);
end
New_pred_idx=1:size(Features,1);                                                  
New_pred_idx(sampleIdx)=[];  
New_sampleIdx=sampleIdx;
end

