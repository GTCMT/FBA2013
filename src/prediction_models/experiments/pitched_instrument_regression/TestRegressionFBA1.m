clear all;
close all;
clc;

addpath(pathdef);

DATA_PATH = 'experiments/pitched_instrument_regression/data/';
write_file_name = 'middleOboe1';

% Check for existence of path for writing extracted features.
  root_path = deriveRootPath();
  full_data_path = [root_path DATA_PATH];
  
  if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
  end
  
NUM_FOLDS = 69;
load([full_data_path write_file_name]);

% Average the assessments to get one label.
labels = mean([labels(:,3),labels(:,2)], 2); %labels(:,3),labels(:,5)

% meanLbl=mean(labels);
% FinalLabels=zeros(size(labels));
% FinalLabels(labels>meanLbl)=1;

% Evaluate model using cross validation.
% [FinalAcc] = crossValidationRegression(FinalLabels, features, NUM_FOLDS);

% greedy feature combination
[~,numFeat]=size(features);
for i=1:numFeat
    [Rsq(i), S(i), p(i), r(i)] = crossValidation(labels, features(:,i), NUM_FOLDS);

%     FeatCombNum{i}=i;
end

[val,loc]=max(r);
[val1,loc1]=max(r);

featureList=1:numFeat;
NewList=[];
NewList=[NewList;featureList(loc)];
AccuList=[val];
Accu_past=val;


featureList(loc)=[];
Accu_present=Accu_past+0.0001;

while Accu_past<Accu_present && isempty(featureList)~=1
    Accu_past=Accu_present;
    AccuArr=zeros(length(featureList),1);
    
    for iter=1:length(featureList)
        [Rsq(iter), S(iter), p(iter), AccuArr(iter)]=crossValidation(labels, [features(:,featureList(iter));features(:,NewList)],NUM_FOLDS);
    
    end
    
    Accu_present=max(AccuArr);
    if Accu_past<Accu_present
        [Accu_present,loc]=max(AccuArr);
        AccuList=[AccuList,Accu_present];
        NewList=[NewList;featureList(loc)];
        featureList(loc)=[];
    end
    
end

% final feature combination confusion matrix
[~,loc2]=max(AccuArr);

%forward selection plot
plot(AccuList);

display('Single feature ranking result');
display(val1);
display('corresponding to feature number');
display(loc1);

display('Best feature combination with')
display(NewList)
display('and the corresponding accuracy')
display(AccuList(end));

% % using all the features
% [Rsq, S, p, r] = crossValidation(labels, features, NUM_FOLDS);
% display('Using all the features');
% fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
%          '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
%          '\nCorrelation coefficient: ' num2str(r) '\n']);
%      