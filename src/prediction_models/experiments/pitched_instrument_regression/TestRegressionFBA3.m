clear all;
close all;
clc;

addpath(pathdef);

DATA_PATH = 'experiments\pitched_instrument_regression\data_acf_altosax\';
write_file_name = 'middleAlto Saxophone2';

% Check for existence of path for writing extracted features.
  root_path = deriveRootPath();
  full_data_path = [root_path DATA_PATH];
  
  if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
  end
  
NUM_FOLDS = 122;
load([full_data_path write_file_name]);

% featuresCombined = features;

% Load Bag Of Features
% DATA_PATH = 'experiments\pitched_instrument_regression\BagOfFeatures_altosax\';
% write_file_name = 'middleAlto Saxophone4';
% 
% % Check for existence of path for writing extracted features.
%   root_path = deriveRootPath();
%   full_data_path = [root_path DATA_PATH];
%   
%   if(~isequal(exist(full_data_path, 'dir'), 7))
%     error('Error in your file path.');
%   end
% 
% load([full_data_path write_file_name]);
% featuresCombined = [featuresCombined features];
% % features=featuresCombined;

% Average the assessments to get one label.
labels = labels(:,1); %labels(:,3),labels(:,5)

% meanLbl=mean(labels);
% FinalLabels=zeros(size(labels));
% FinalLabels(labels>meanLbl)=1;

% Evaluate model using cross validation.
[Rsq_allFeat, S_allFeat, p_allFeat, r_allFeat] = crossValidation(labels, features, NUM_FOLDS);
display('With all the features');
display(r_allFeat);
display(p_allFeat);

% greedy feature combination: forward direction
[~,numFeat]=size(features);
for i=1:numFeat
    [Rsq(i), S(i), p(i), r(i)] = crossValidation(labels, features(:,i), NUM_FOLDS);
end

[val,loc]=max(r);
display('Single feature ranking result');
display(val);
display('P value');
display(p(loc));
display('corresponding to feature number');
display(loc);

Regr(1,1)=r_allFeat;
Regr(2,1)=p_allFeat;
Regr(1,2)=val;
Regr(2,2)=p(loc);

featureList=1:numFeat;
NewList=[];
NewList=[NewList;featureList(loc)];
AccuList=[val];
Accu_past=val;
p_max=p(loc);


featureList(loc)=[];
Accu_present=Accu_past+0.0001;

while isempty(featureList)~=1
    Accu_past=Accu_present;
    AccuArr=zeros(length(featureList),1);
    
    for iter=1:length(featureList)
        [Rsq(iter), S(iter), p(iter), AccuArr(iter)]=crossValidation(labels, [features(:,featureList(iter)) features(:,NewList')],NUM_FOLDS);
    
    end
    
    Accu_present=max(AccuArr);
%     if Accu_past<Accu_present
        [Accu_present,loc]=max(AccuArr);
        AccuList=[AccuList,Accu_present];
        NewList=[NewList;featureList(loc)];
        featureList(loc)=[];
        p_max=p(loc);
%     end
    
end

% [~,loc2]=max(AccuArr);

%forward selection plot
plot(AccuList);

display('Best feature combination with')
display(NewList)
display('and the corresponding accuracy')
display(AccuList(end));

Regr(1,3)=AccuList(end);
Regr(2,3)=p_max;

% greedy feature combination: backward direction
[val]=r_allFeat;

featureListBack=1:numFeat;
AccuListBack=[val];
Accu_past=val;
BackFeatDrop=[];
Accu_present=Accu_past+0.0001;

while isempty(featureListBack)~=1
    Accu_past=Accu_present;
    AccuArrBack=zeros(length(featureListBack),1);
    
    for iter=1:length(featureListBack)
        TempFeatList=featureListBack;
        TempFeatList(:,iter)=[];
        [Rsq(iter), S(iter), p(iter), AccuArrBack(iter)]=crossValidation(labels,features(:,TempFeatList),NUM_FOLDS);
    end
    
    Accu_present=max(AccuArrBack);
%     if Accu_past<Accu_present
        [Accu_present,loc]=max(AccuArrBack);
        AccuListBack=[AccuListBack,Accu_present];
        BackFeatDrop=[BackFeatDrop;featureListBack(loc)];
        featureListBack(loc)=[];
%     end
    
end

% final feature combination confusion matrix
% [~,loc2]=max(AccuArrBack);

%forward selection plot
figure; plot(AccuListBack);

display('Best feature combination with')
display(featureListBack)
display('and the corresponding accuracy')
display(AccuListBack(end));
display('with p value of');
display(p(loc));

Regr(1,4)=AccuListBack(end);
Regr(2,4)=p(loc);
