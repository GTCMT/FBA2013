%% get the distribution information of judges' grading
% CW @ GTCMT 2016
% Input:
%   band_option = string: 'middle', 'concert', or 'symphonic' 
%   instrument_option = string: full name of the instrument (ex. 'Flute') 
%   segment_option = string to specify the segment (10 in total)
% Output:
%   assessments = float matrix, numStudents by numCategories
%   categoryName = string cell vector, numCategories by 1
%   idx = int vector, corresponding category index

function [assessments, categoryName, idx] = getDistributionInfo(band_option, instrument_option, segment_option)

% set parameter 
addpath('../../scanning/');
fba_relative_path = '../../../FBA2013/';
score_option = [];

% get assessments 
audition_metadata = scanFBA(fba_relative_path, band_option, ...
                                     instrument_option, segment_option, ...
                                     score_option);
                                 
% organize information 
numStudents = length(audition_metadata.assessments);                                 
idx = find(audition_metadata.assessments{1} ~= -1);
assessments = zeros(numStudents, length(idx));
categoryName = cell(length(idx), 1);

for i = 1:length(idx)
    currentCategory = idx(i);
    for j = 1:numStudents
        assessments(j, i) = audition_metadata.assessments{j}(currentCategory);
    end
    
    categoryName{i} = getCategoryName(currentCategory);
    segmentName = getSegmentName(segment_option);
end
clc;
fprintf('=== quick summary: === \n');
fprintf('number of students = %g\n', numStudents);
fprintf('number of categories = %g\n', length(idx));
rmpath('../../scanning/');