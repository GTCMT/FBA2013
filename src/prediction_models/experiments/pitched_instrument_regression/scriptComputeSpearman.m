%% script to compute Spearman correlation between features and labels
% performs outlier removal on training data also

close all;
fclose all;
clear all;
clc;

%% specify experiment parameters
% specify data folder
dataFolder = 'dataPyin'; % change to 'dataPyin' torun for pYin features
% specify feature type
feature_type = 'Combined'; % options are 'Score', 'NonScore', 'Combined'

%% define file paths and read feature data
if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end

% Check for existence of path for writing extracted features.
DATA_PATH = ['experiments', slashtype, 'pitched_instrument_regression' slashtype, dataFolder, slashtype];
root_path = deriveRootPath();
full_data_path = [root_path DATA_PATH];

if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
end

% read stored feature matrices and labels
remove_id = [14, 88];
num_years = 3;
year = {'2013', '2014', '2015'};
feat_mat = [];
label_mat = [];
for j =1:num_years
    filename = [full_data_path , 'middleAlto Saxophone2_', feature_type, '_', year{j}, '.mat'];
    load(filename);
    if j == 1
        features(remove_id,:) = [];
        labels(remove_id,:) = [];
    end
    feat_mat = [feat_mat; features];
    label_mat = [label_mat; labels];
end


%% Compute correlation

% assign variables to store results
num_features = size(feat_mat,2);
results_test = cell(4, 1);
% for j = 1:num_years
%     results_test{j} = zeros(num_features, 2*4); % 4 for labels, 2 for r and p value
% end

% iterate over different test years
% for test_idx = 1:num_years
%     % iterate over labels
%     % 1: musicality, 2: note accuracy, 3: rhythmic accuracy, 4: tone quality
    for l = 1:4
        results_test{l} = zeros(num_features, 2);
        labels = label_mat(:,l);
        [r, p] = corr(feat_mat, labels, 'type', 'Spearman');
        results_test{l}(:,1) = r;
        results_test{l}(:,2) = p;
    end
% end

%% Perform feature selection using Spearman correlation
selected_features = cell(4,1);

for l = 1:4
    results = results_test{l};
    [~, indices] = sortrows(results, -1);
    selected_features{l} = indices(1:10);
end


