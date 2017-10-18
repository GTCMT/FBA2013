% AV@GTCMT
% Objective: Use the model trained on 2 years of data (after removing 5% of outliers)
% and test on the remaining year's data
% DATA_PATH holds the path of the mat file i.e. the path of 'data' folder
% and the write_file_name has the name of the feature mat file (line 13 and 29 for the train years)
% for the test year the write_file_name is on line 68
close all;
fclose all;
clear all;
clc;

DATA_PATH = 'experiments/pitched_instrument_regression/data/';
% delFeat = [24]; %[10:17,24]; %9, 12, 17, 21, % 23:30 amp features or 10:17

% testing
%musicality %top10=[1;3;4;8;9;11;13;14;19;21;22;23;26;30;31;34;35;37;38;39;41;44;45;46];%intersctn=[12,26,34,38]; %bestUnin=[1;2;3;4;5;7;8;9;11;12;13;14;15;16;18;19;20;21;22;23;25;26;27;29;30;31;33;34;35;36;37;38;39;40;41;42;43;44;45;46];
%noteaccu %top10=[2;3;5;8;9;10;12;13;14;15;16;21;22;24;25;26;28;29;32;37;39;41;43;45]; %intersectn=[21;22;30;46]; bestUnin =[2;3;4;5;7;8;9;10;12;13;14;15;16;18;19;20;21;22;24;25;26;27;28;29;30;32;33;34;35;36;37;39;40;41;43;45;46];
%rhythmic %top10=[1;3;9;10;11;12;13;14;15;21;22;26;27;30;31;34;36;37;38;39;41;43;45;46]; %intersctn=[12;13;37]; bestUnin=[1;3;5;8;9;10;11;12;13;14;15;16;21;22;23;24;25;26;27;28;29;30;31;33;34;36;37;38;39;40;41;42;43;44;45;46];
%tone quality %top10=[1;5;6;9;10;12;14;16;21;22;23;24;25;26;27;30;34;35;37;38;39;40;41;42;43;45;46]; %intersectn =[3;4;12;15;37]; %bestUnion =[1;2;3;4;5;6;7;8;9;10;12;13;14;15;16;20;21;22;23;24;25;26;27;28;29;30;32;33;34;35;37;38;39;40;41;42;43;44;45;46];

% training
% musicality top10 [1;4;5;7;8;9;11;14;15;20;21;23;30;31;35;39;40;41;42;43;45]
% noteaccu top 10 [1;3;4;6;7;9;10;12;13;14;16;19;21;22;24;30;38;40;41;42;45;46]
% rhythmic top10 [1;2;3;5;9;10;11;13;14;15;16;17;22;28;32;34;36;41;42;45;46]
% tone top10 [1;8;10;11;12;14;15;16;20;21;22;25;28;30;32;34;36;39;40;41;44;45]
% unionSet = [1;3;4;6;7;9;10;12;13;14;16;19;21;22;24;30;38;40;41;42;45;46];
% delFeat(unionSet)=[];
% delFeat = 1:46;

% Check for existence of path for writing extracted features.
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end

results_mat_train = [];
results_mat_test = [];
FinalPredictions = [];

yr1 = 3; yr2 = 4; yr3 = 5;
for l = 2:5
    
write_file_name = ['LatestScoreNonScoreConcat_201' num2str(yr1)];

% Check for existence of path for writing extracted features.
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end
  
load([full_data_path write_file_name]);
[features, featr_test] = NormalizeFeatures(features, ones(size(features,2),1)');
% features(:,14)=features(:,14)./features(:,23);
% features(:,delFeat)=[];

features1 =features;

% Average the assessments to get one label.
labels1 = labels(:,l); %labels(:,3),labels(:,5)

write_file_name = ['LatestScoreNonScoreConcat_201' num2str(yr2)];
load([full_data_path write_file_name]);
% features(:,14)=features(:,14)./features(:,23);
% features(:,delFeat)=[];

[features, featr_test] = NormalizeFeatures(features, ones(size(features,2),1)');
features = [features; features1];
labels = labels(:,l); %labels(:,3),labels(:,5)
labels = [labels; labels1];

NUM_FOLDS = length(labels);
% remove top 5% outliers and test
[Rsq, S, p, r, predictions] = crossValidation(labels, features, NUM_FOLDS);
err=abs(labels-predictions);
[sort_err,idx_err]=sort(err,'descend');
new_features=features;
%new_labels=predictions;
% new_labels = labels;
loopLen = floor(0.05*length(labels));

for i=1:loopLen
    
    new_features(idx_err(1),:)=[];
    labels(idx_err(1)) = [];

    NUM_FOLDS=NUM_FOLDS-1;
    [Rsq, S, p, r, new_predictions] = crossValidation(labels, new_features, NUM_FOLDS);

    err=abs(labels-new_predictions);
    [sort_err,idx_err]=sort(err,'descend');

%     fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
%      '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
%      '\nCorrelation coefficient: ' num2str(r) '\n']);
end

result_train = [r;p;Rsq;S];
results_mat_train = [results_mat_train,result_train];

% figure; plot(labels,new_predictions,'*'); xlabel('Test Labels'); ylabel('Prediction');
% training features from 2013
train_features = new_features;
train_labels = labels;
clear labels; clear features;

% test features from either 2014 or 2015
write_file_name = ['LatestScoreNonScoreConcat_201' num2str(yr3)];
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];
load([full_data_path write_file_name]);
[features, featr_test] = NormalizeFeatures(features, ones(size(features,2),1)');
% features(:,14)=features(:,14)./features(:,23);
% features(:,delFeat)=[];

test_features = features;
test_labels = labels(:,l-1);
clear labels; clear features;

% Normalize
[train_features, test_features] = NormalizeFeatures(train_features, test_features);
% feature truncation
% test_features(test_features >= 1) = 1;
% test_features(test_features <= 0) = 0;
% locations_truncated = (test_features >= 1) + (test_features <= 0);

% remove top 2 most truncated features
% countTruncation = sum(locations_truncated);
% [val,loc]=max(countTruncation);
% train_features(:,loc)=[];
% test_features(:,loc)=[];
% countTruncation(loc)=[];
% [val,loc]=max(countTruncation);
% train_features(:,loc)=[];
% test_features(:,loc)=[];

% Train the classifier and get predictions for the current fold.
svm = svmtrain(train_labels, train_features, '-s 4 -t 0 -q');
predictions = svmpredict(test_labels, test_features, svm, '-q');

predictions(predictions>1)=1;
predictions(predictions<0)=0;
[Rsq, S, p, r] = myRegEvaluation(test_labels, predictions); 
[r_s, p_s] = corr(test_labels, predictions, 'type', 'Spearman');

FinalPredictions=[FinalPredictions,predictions];

result_test = [r;p;r_s; p_s; Rsq;S];
results_mat_test = [results_mat_test,result_test];

fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
         '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
         '\nCorrelation coefficient: ' num2str(r) '\n']);

% figure; plot(test_labels,predictions,'*'); xlabel('Test Labels'); ylabel('Prediction');
end

save(['Predictions Saxophone2_baseline_201' num2str(yr3)],'FinalPredictions');

% xlswrite('result_train_baseline_2013_14', results_mat_train);
% xlswrite('result_test_baseline_2015', results_mat_test);