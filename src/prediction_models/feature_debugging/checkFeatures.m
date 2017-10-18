%% this script is to double check the problematic features
% presented in amruta's experiments
% CW @ GTCMT 2017

function [problem_id] = checkFeatures(testYear)

% ==== train/test splits
% note that combined features = [score, nonscore]
load('./fwdfbamatfiles/middleAlto Saxophone2_Combined_2013.mat');
features2013 = features;
load('./fwdfbamatfiles/middleAlto Saxophone2_Combined_2014.mat');
features2014 = features;
load('./fwdfbamatfiles/middleAlto Saxophone2_Combined_2015.mat');
features2015 = features;

if testYear == 2013
    trainData = [features2014; features2015];
    testData  = features2013; 
elseif testYear == 2014
    trainData = [features2013; features2015];
    testData  = features2014;     
else
    trainData = [features2013; features2014];
    testData  = features2015;     
end

%==== normalized the features
%[featr_train, featr_test] = NormalizeFeatures(trainData, testData);

% compare with my normalization methods (yes they are the same)
[trainData_norm, minlist, maxlist] = featureScaling(trainData');
trainData_norm = trainData_norm';

[testData_norm] = featureScaling(testData', minlist, maxlist);
testData_norm = testData_norm';

%==== visualization
test_min = min(testData_norm, [], 1);
test_max = max(testData_norm, [], 1);

plot(test_min, '.-r'); hold on;
plot(zeros(length(test_min), 1), '*-r');
plot(test_max, '.-b'); hold on;
plot(ones(length(test_min), 1), '*-b');
legend('test min', 'lower boundary', 'test max', 'upper boundary');
title(strcat('test data =', num2str(testYear)));
axis([0 50 -0.5 2.5]);

%==== rank the problematic features
ind = 1:length(test_min);
sort_min = [test_min; ind]';
sort_min = sortrows(sort_min);
sort_max = [test_max; ind]';
sort_max = flipud(sortrows(sort_max));
fprintf('==== Top 10 problematic features (by max values):====\n');
fprintf('Problematic feature id = %g\n', sort_max(1:10, 2));
fprintf('==== Top 10 problematic features (by min values):====\n');
fprintf('Problematic feature id = %g\n', sort_min(1:10, 2));

%==== find the problematic student ID
fprintf('==== Selected feature ====\n');
interested_feature = input('enter the interested feature index:\n');
tmp = testData_norm(:, interested_feature);
problem_id = find(tmp == max(tmp));
fprintf('Interested feature = %g\n', interested_feature);
fprintf('Problematic student id = %g\n', problem_id);

end
