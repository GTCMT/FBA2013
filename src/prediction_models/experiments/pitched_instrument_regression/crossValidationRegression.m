% Function to give average accuracy after n_fold cross validation using
% regression from libsvm

function [FinalAccu] = crossValidationRegression(labels, features, n_fold)

% Preallocate memory.
num_data = size(labels, 1);
predictions = zeros(num_data, 1);
sorted_labels = zeros(num_data, 1);

% Proportional distributions of classes among folds.
folds = cvpartition(labels, 'KFold', n_fold);

% Evaluate one fold at a time.
data_start_idx = 1;
for (fold = 1:n_fold)
  % Grab the test data.
  test_indices = folds.test(fold);
  test_labels = labels(test_indices, :);
  test_features = features(test_indices, :);
  
  % Get training data.
  train_indices = folds.training(fold);
  train_labels = labels(train_indices, :);
  train_features = features(train_indices, :);
  
  % Zero-cross whitening.
  [train_features, test_features] = whiten(train_features, test_features);
  
  % Train the classifier and get predictions for the current fold.
  svm = svmtrain(train_features,train_labels);
% [r,m,b] = regression(t,y);
  cur_predictions = svmclassify(svm, test_features);
  
  % Store current predictions and their corresponding labels.
%   num_test_data = size(test_labels, 1);
%   data_stop_idx = data_start_idx + num_test_data - 1;
%   predictions(data_start_idx:data_stop_idx) = cur_predictions;
%   sorted_labels(data_start_idx:data_stop_idx) = test_labels;
%   
%   data_start_idx = data_start_idx + num_test_data;

acc(fold)=sum(cur_predictions==test_labels)/length(test_labels);
end

% [Rsq, S, p, r] = myRegEvaluation(sorted_labels, predictions);
FinalAccu=mean(acc);

end