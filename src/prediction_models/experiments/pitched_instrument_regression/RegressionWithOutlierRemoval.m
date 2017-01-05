clear all;
close all;
clc;

% AV@GTCMT
% Objective: Test if removing 5% of outliers is helping to improve the
% correlation. Code is run on the feature mat files stored in data folder
% in a leave one song out validation using SVR
% DATA_PATH holds the path of the mat file i.e. the path of 'data' folder
% and the write_file_name has the name of the feature mat file
% Specify the number of folds for the crossvalidation in NUM_FOLDS
% variable.

DATA_PATH = 'experiments/pitched_instrument_regression/data/';
write_file_name = 'middleAlto Saxophone2_designedFeatures_2015';

% Check for existence of path for writing extracted features.
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end
  
load([full_data_path write_file_name]);

% % % To perform the same experiment with bag of features (standard audio features) plus the designed 
% features_designed=features;
% 
% DATA_PATH = 'experiments\pitched_instrument_regression\ICMPC_baseline_altosax_middleschool\';
% write_file_name = 'middleAlto Saxophone2';
% 
% load([full_data_path write_file_name]);
% features=[features,features_designed];

% Average the assessments to get one label.
labels = labels(:,1); %labels(:,3),labels(:,5)
NUM_FOLDS = length(labels);

% consider the PCA transformed features with 95% variability 
[row,col]=size(features);
dummy = ones(1,col);
[normFeat, dum] = NormalizeFeatures(features,dummy);
[coeff,score,latent,tsquared,explained,mu]=pca(normFeat);
for i =1:length(explained)
    if sum(explained(1:i))>=95
        featNum=i;
        break;
    end
end

% remove 5% outliers
[Rsq, S, p, r, predictions] = crossValidation(labels, score, NUM_FOLDS);
% for PCA
[Rsq, S, p, r, predictions] = crossValidation(labels, score(:,1:featNum), NUM_FOLDS);
err=abs(labels-predictions);
[sort_err,idx_err]=sort(err,'descend');
% new_features=features;

new_features=score(:,1:featNum);
new_labels = labels;

for i=1:floor(0.05*length(labels))
    
    new_features(idx_err(1),:)=[];
    new_labels(idx_err(1)) = [];

    NUM_FOLDS=NUM_FOLDS-1;
    [Rsq, S, p, r, new_predictions] = crossValidation(new_labels, new_features, NUM_FOLDS);

    err=abs(new_labels-new_predictions);
    [sort_err,idx_err]=sort(err,'descend');

    fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
     '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
     '\nCorrelation coefficient: ' num2str(r) '\n']);
end
  


