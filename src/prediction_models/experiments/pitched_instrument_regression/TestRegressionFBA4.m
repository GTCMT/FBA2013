% AV@GTCMT
% Objective: Use the 2013 model (after removing top 5% of features) to test
% for 2014 and 2015 data
% So the DATA_PATH holds the path of the mat file i.e. the 'data' folder
% and the write_file_ICMPC_designed_acf_altosax_middleschool variable has the name of the mat file
% Specify the number of folds for the crossvalidation in NUM_FOLDS
% variable. Here I have done a leave one song out validation

close all;
fclose all;
clear all;
clc;

addpath(pathdef);

DATA_PATH = 'experiments/pitched_instrument_regression/data/';
write_file_name = 'ForModel2013_After5percntOutlierRemoval_Musicality';

% Check for existence of path for writing extracted features.
  root_path = deriveRootPath();
  full_data_path = [root_path DATA_PATH];
  
  if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
  end
  
load([full_data_path write_file_name]);

% training features from 2013
train_features = features;
train_labels = labels;
clear labels; clear features;

% test features from either 2014 or 2015
write_file_name = 'middleAlto Saxophone2_designedFeatures_2015';
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];
load([full_data_path write_file_name]);
test_features = features;
test_labels = labels(:,1);
clear labels; clear features;

% Normalize
[train_features, test_features] = NormalizeFeatures(train_features, test_features);
  
% Train the classifier and get predictions for the current fold.
svm = svmtrain(train_labels, train_features, '-s 4 -t 0 -q');
predictions = svmpredict(test_labels, test_features, svm, '-q');
  
[Rsq, S, p, r] = myRegEvaluation(test_labels, predictions);  

fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
         '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
         '\nCorrelation coefficient: ' num2str(r) '\n']);
