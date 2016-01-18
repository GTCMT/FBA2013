clear all;
close all;
clc;

addpath(pathdef);

DATA_PATH = 'experiments/pitched_instrument_regression/data/';
write_file_name = 'middleOboe4';

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

% remove top 5% features and test
[Rsq, S, p, r, predictions] = crossValidation(labels, features, NUM_FOLDS);
err=labels-predictions;
[sort_err,idx_err]=sort(err,'descend');

for i=1:0.05*length(sort_err)
      new_features=features;
      new_features(idx_err(i),:)=[];
      new_labels=predictions;
      new_labels(idx_err(i))=[];
      NUM_FOLDS=NUM_FOLDS-1;
      [Rsq, S, p, r, new_predictions] = crossValidation(new_labels, new_features, NUM_FOLDS);
      
      err=new_labels-new_predictions;
    [sort_err,idx_err]=sort(err,'descend');
    
    fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
         '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
         '\nCorrelation coefficient: ' num2str(r) '\n']);
end
  


