function [ Xhat ] = JKBoot( X )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for ii=1:size(X,1)
    temp=X;
    temp(ii,:)=[];
    Xhat(:,:,ii)=temp;clear temp
end

