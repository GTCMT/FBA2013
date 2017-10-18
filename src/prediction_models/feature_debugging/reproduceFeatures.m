%% this script is used for debugging the features 
% CW @ GTCMT 2017

clear all; clc; close all;

BAND_OPTION = 'middle';
INSTRUMENT_OPTION = 'Alto Saxophone';
year_option = '2014';
segment = 2;
NUM_FEATURES = 24; %this argument is probably not important

%% NOTE: 
% this function will ask you to select a feature of interest
[problem_id] = checkFeatures(str2double(year_option));

% make sure to enter your FBA audio folder as well
audio_path = '/Volumes/CW_MBP15/Datasets/FBA/';

%% construct a path to the actual file
student_ids = scanStudentIds(BAND_OPTION, INSTRUMENT_OPTION, year_option);

for i = 1:length(problem_id)
   cur_id = student_ids(problem_id(i)); 
   fprintf('currently examining %g\n', cur_id);
   cd('../experiments/pitched_instrument_regression/');
   % NOTE: if you want to debug the features, set your break points below
   % and step in! 
   [features, labels] = getFeatureForSegment(BAND_OPTION, INSTRUMENT_OPTION, segment, year_option, NUM_FEATURES, audio_path, problem_id(i));
   cd('../feature_debugging/');
end