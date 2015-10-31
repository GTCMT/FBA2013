%% LOO analysis of snare etude
% objective : evaluate regression models
% Chih-Wei Wu, GTCMT, 2014/09
clear all; close all; clc;

%% load data
load ../../../../../FBAdataset/experiment_data/cb_baseline.mat
data1 = summaryFeatures;
load ../../../../../FBAdataset/experiment_data/middle_baseline.mat
data2 = summaryFeatures;
load ../../../../../FBAdataset/experiment_data/sym_baseline.mat
data3 = summaryFeatures;
%data_content = [data1; data2; data3];
data_content = [data1];

load ../../../../../FBAdataset/experiment_data/cb_rhythmic.mat
data1 = summaryFeatures;
load ../../../../../FBAdataset/experiment_data/middle_rhythmic.mat
data2 = summaryFeatures;
load ../../../../../FBAdataset/experiment_data/sym_rhythmic.mat
data3 = summaryFeatures;
%data_rhythmic = [data1; data2; data3];
data_rhythmic = [data1];

data = [data_content(:, 1:end-3), data_rhythmic];
%data = [data_content];
%data = [data_rhythmic];

%% experiment setting
dataID = 1:size(data, 1);
select = -2; %-2 musicality, -1 note acc, 0 rhythm acc

%%
cd ../../evaluation

%initialization
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
        trainData   = others(:, 1:(numFeatures-3));
        trainLabels = others(:, cate); %hard-coded
        testData    = choosen(:, 1:(numFeatures-3));
        testLabels  = choosen(:, cate);

        %train SVR model
        svrModel     = svmtrain(trainLabels, trainData, '-s 4 -t 2 -g 0.01 -q');

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
    fprintf('\n\n========Results=======\n');
    fprintf('The  p is %g \n', p(k));
    fprintf('The  r is %g \n', r(k));
    fprintf('The  R^2 is %g \n', Rsq(k));
    fprintf('The  S is %g \n', S(k));

end

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

cd ../experiments/snare_etude_regression


