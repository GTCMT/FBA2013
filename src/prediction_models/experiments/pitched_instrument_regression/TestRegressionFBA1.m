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

% Average the assessments to get one label.
labels = mean([labels(:,3),labels(:,2)], 2); %labels(:,3),labels(:,5)

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

[~,loc2]=max(AccuArr);

%forward selection plot
plot(AccuList);

display('Single feature ranking result');
display(val1);
display('P value');
display(p(loc1));
display('corresponding to feature number');
display(loc1);

display('Best feature combination with')
display(NewList)
display('and the corresponding accuracy')
display(AccuList(end));

% greedy feature combination: backward direction
[val]=r_allFeat;
[val1]=r_allFeat;

featureListBack=1:numFeat;
AccuListBack=[val];
Accu_past=val;

Accu_present=Accu_past+0.0001;

while Accu_past<Accu_present && isempty(featureListBack)~=1
    Accu_past=Accu_present;
    AccuArrBack=zeros(length(featureListBack),1);
    
    for iter=1:length(featureListBack)
        TempFeatList=featureListBack;
        TempFeatList(:,iter)=[];
        [Rsq(iter), S(iter), p(iter), AccuArrBack(iter)]=crossValidation(labels,features(:,TempFeatList),NUM_FOLDS);
    end
    
    Accu_present=max(AccuArrBack);
    if Accu_past<Accu_present
        [Accu_present,loc]=max(AccuArrBack);
        AccuListBack=[AccuListBack,Accu_present];
        featureListBack(loc)=[];
    end
    
end

% final feature combination confusion matrix
[~,loc2]=max(AccuArrBack);

%forward selection plot
figure; plot(AccuListBack);

display('Single feature ranking result');
display(val1);
display('P value');
display(p(loc1));
display('corresponding to feature number');
display(loc1);

display('Best feature combination with')
display(NewListBack)
display('and the corresponding accuracy')
display(AccuListBack(end));

