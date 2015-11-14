clear all;
close all;
clc;

DATA_PATH = 'experiments/pitched_instrument_regression/data/';
write_file_name = 'middleOboe2';

% Check for existence of path for writing extracted features.
  root_path = deriveRootPath();
  full_data_path = [root_path DATA_PATH];
  
  if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
  end
  
NUM_FOLDS = 69;
load([full_data_path write_file_name]);

% Average the assessments to get one label.
labels = mean([labels(:,3),labels(:,5)], 2);

% meanLbl=mean(labels);
% FinalLabels=zeros(size(labels));
% FinalLabels(labels>meanLbl)=1;

% Evaluate model using cross validation.
% [FinalAcc] = crossValidationRegression(FinalLabels, features, NUM_FOLDS);

[Rsq, S, p, r] = crossValidation(labels, features, NUM_FOLDS);
fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
         '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
         '\nCorrelation coefficient: ' num2str(r) '\n']);
     