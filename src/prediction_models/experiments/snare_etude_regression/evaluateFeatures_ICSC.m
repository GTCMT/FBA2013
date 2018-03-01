%% Repeat experiments of ICSC paper using pre-extracted features
% Chih-Wei Wu, GTCMT, 2018
clear all; close all; clc;

%% ==== 0) determine combinations 
% 1: baseline
% 2: designed
% 3: learned
% 4: baseline + designed
% 5: baseline + learned
% 6: designed + learned
featureSet = 4;
category = 'musicality'; % 'rhythmAcc'

%% ==== 1) load data ======================================================
data_baseline = [];
load ./extractedFeatures/middle_baseline_2013.mat
data_baseline = [data_baseline; summaryFeatures];
load ./extractedFeatures/middle_baseline_2014.mat
data_baseline = [data_baseline; summaryFeatures];
load ./extractedFeatures/middle_baseline_2015_fix.mat
data_baseline = [data_baseline; summaryFeatures];

data_nonscoreDesigned = [];
load ./extractedFeatures/middle_rhythmic_2013.mat
data_nonscoreDesigned = [data_nonscoreDesigned; summaryFeatures];
load ./extractedFeatures/middle_rhythmic_2014.mat
data_nonscoreDesigned = [data_nonscoreDesigned; summaryFeatures];
load ./extractedFeatures/middle_rhythmic_2015_fix.mat
data_nonscoreDesigned = [data_nonscoreDesigned; summaryFeatures];

data_learned = [];
load ./extractedFeatures/D_2013_2014_2015_k32_10sec_ioi_norm_amp_mfcc_fix.mat
featureMatrix_re(31, :) = [];
data_learned = featureMatrix_re;

if featureSet == 1
    data = [data_baseline];
elseif featureSet == 2
    data = [data_nonscoreDesigned];
elseif featureSet == 3
    data = [data_learned];
elseif featureSet == 4
    data = [data_baseline(:, 1:end-3), data_nonscoreDesigned];
elseif featureSet == 5
    data = [data_baseline(:, 1:end-3), data_learned];
elseif featureSet == 6
    data = [data_learned(:, 1:end-3), data_nonscoreDesigned];
end

%% ==== 2) Experiment setting =============================================
dataID = 1:size(data, 1);
if strcmp(category, 'musicality')
    select = -2;
elseif strcmp(category, 'rhythmAcc')
    select = 0;
end
numLabels = 3;
%% ==== 3) Main loop ======================================================
trial      = floor( length(data)*0.05 );
outlierIdx = zeros(trial, 1);
outlierID = zeros(trial, 1);

for k = 1:trial
    [numSamples, numFeatures] = size(data);
    prediction = zeros(numSamples, 1);
    residual   = zeros(numSamples, 1);

    %leave one out loop
    for i = 1:numSamples

        %split the data
        choosen = data(i, :);
        ind = find([1:numSamples] ~= i);
        others  = data(ind, :);

        %select score category
        cate = numFeatures + select;
        trainData   = others(:, 1:(numFeatures-numLabels));
        trainLabels = others(:, cate); %hard-coded
        testData    = choosen(:, 1:(numFeatures-numLabels));
        testLabels  = choosen(:, cate);
        
        %== normalize training data
        trainData = trainData';
        [trainData, minList, maxList] = featureScaling(trainData);
        trainData = trainData';
        
        %== apply the same parameter, normalize testing data
        testData   = choosen(:, 1:(numFeatures-numLabels));
        testData   = testData';
        [testData] = featureScaling(testData, minList, maxList);
        testData   = testData';
        testLabels = choosen(:, cate);
        
        %train SVR model
        svrModel      = svmtrain(trainLabels, trainData, '-s 4 -t 0 -q');

        %test SVR model
        testResults   = svmpredict(testLabels, testData, svrModel, '-q');
        
        prediction(i) = testResults;
        residual(i)   = testResults - testLabels;

    end
    
    %evaluate
    y = data(:, cate);
    f = prediction;
    [Rsq(k), S(k), p(k), r(k)] = myRegEvaluation(y, f);
    
    %take out outliers
    [~, outlierIdx(k)] = max(abs(residual));
    outlierID(k) = dataID(outlierIdx(k));
    dataID(outlierIdx(k)) = [];
    
    ind2  = find([1:size(data,1)] ~= outlierIdx(k));
    data = data(ind2, :);
end

fprintf('\n\n========Results=======\n');
fprintf('The  p is %g \n', p(k));
fprintf('The  r is %g \n', r(k));
fprintf('The  R^2 is %g \n', Rsq(k));
fprintf('The  S is %g \n', S(k));

%% ==== 4) Visualization
plot(r, 'r'); hold on;
plot(p, 'g'); hold on;
plot(S, 'b'); hold on;
plot(Rsq, 'k'); 
legend('r', 'p', 'S', 'Rsq');
xlabel(' # outlier removed');
ylabel(' values ');

figure;
scatter(y, f);
xlabel('ground truth');
ylabel('prediction');
axis([0 1 0 1]);



