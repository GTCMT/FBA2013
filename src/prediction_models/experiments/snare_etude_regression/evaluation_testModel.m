%% Evaluation: use trained svr model, test on new data
% Chih-Wei Wu, GTCMT, 2016/01
clear all; close all; clc;

%% ==== 1) load data
load /Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/middle_baseline_2015.mat
data_content = summaryFeatures;

load /Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/middle_rhythmic_2015.mat
data_rhythmic = summaryFeatures;

%data = [data_content(:, 1:end-3), data_rhythmic];
%data = [data_content];
data = [data_rhythmic];

%% ==== 2) load model
load /Users/cw/Documents/CW_FILES/02_Github_repo/GTCMT/FBA_cw_local_workspace/experiment_data/svrModel_middle_2014_2015_rhythmic_music.mat

%% ==== 3) experiment setting
dataID = 1:size(data, 1);
select = -2; %-2 musicality, -1 note acc, 0 rhythm acc

%== initialization
[numSamples, numFeatures] = size(data);
prediction = zeros(numSamples, 1);
residual   = zeros(numSamples, 1);
choosen = data(:, :);

%== select score category
cate = numFeatures + select;
        
%% ==== 4) feature scaling (using same param as training data)
testData    = choosen(:, 1:(numFeatures-3));
testData = testData';
[testData] = featureScaling(testData, minList, maxList);
%== test feature truncation
% testData(testData >= 1) = 1;
% testData(testData <= 0) = 0;
testData = testData';
testLabels  = choosen(:, cate);

%% ==== 5) test SVR model
testResults   = svmpredict(testLabels, testData, svrModel, '-q');
prediction = testResults;
residual   = testResults - testLabels;
%== test output truncation
prediction(prediction >= 1) = 1;
prediction(prediction <= 0) = 0;


%% ==== 6) evaluate and print out results
y = data(:, cate);
f = prediction;
[Rsq, S, p, r] = myRegEvaluation(y, f);

fprintf('\n\n========Results=======\n');
fprintf('The  p is %g \n', p);
fprintf('The  r is %g \n', r);
fprintf('The  R^2 is %g \n', Rsq);
fprintf('The  S is %g \n', S);

figure;
scatter(y, f);
xlabel('ground truth');
ylabel('prediction');
axis([0 1 0 1]);



