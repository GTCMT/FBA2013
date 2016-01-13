%% Visualize the distribution of judges' grading
% CW @ GTCMT 2016
% Input:
%   band_option = string: 'middle', 'concert', or 'symphonic' 
%   instrument_option = string: full name of the instrument (ex. 'Flute') 
%   segment_option = string to specify the segment (10 in total)
% Output:
%   

function visualizeDistribution(band_option, instrument_option, segment_option)

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
for i = 1:length(idx)
    currentCategory = idx(i);
    for j = 1:numStudents
        assessments(j, i) = audition_metadata.assessments{j}(currentCategory);
    end
    figure;
    categoryName = getCategoryName(currentCategory);
    segmentName = getSegmentName(segment_option);
    hist(assessments(:, i), [0:0.1:1]);
    plotTitle = strcat('Group=', band_option, '  Instrument=', instrument_option,...
        '  Segment=', segmentName, '  Category=', categoryName);
    title(plotTitle);
end
clc;
fprintf('=== quick summary: === \n');
fprintf('number of students = %g\n', numStudents);
fprintf('number of categories = %g\n', length(idx));


rmpath('../../scanning/');