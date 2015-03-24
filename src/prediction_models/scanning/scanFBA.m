%% Scans the FBA dataset, returning metadata about student auditions. 
% CL@GTCMT 2015
% Metadata is returned in the form of a struct, audition_metadata, which is
% described below.
%
%                         %%%% Input %%%%
% fba_relative_path: string, the relative path to the FBA2013 directory 
%                    containing audio files in your computer's file system.
% band_option:       string specifying the band: 'middle', 'concert' 
%                    or 'symphonic'
% instrument_option: string specifying instrument as it appears in the xls
% segment_option: N*1 int vector, specify your target segments, ex: [3; 5]
% assessment_option: N*2 int vector, N -> assessments per student, 
%                    1st column = segment, 2nd column = category. 
%                    See /FBA2013/README.txt for index values. ex: for
%                    technical etude tone quality and note accuracy, use
%                    [2 6; 2 4].
%
%                         %%%% Output %%%%
% Fields of audition_metadata:
%   file_paths: string, the path to each audio file for a student.
%   segments: N*1 cell vector, each cell is a m*2 matrix,
%             1st column = starting time, 2nd column = duration.
%   assessments: N*1 cell vector, each cell is a m*1 vector,
%                N -> student_id's, m -> assessments, order taken from 
%                assessment_option, -1 indicates missing assessment.
%   score: TODO(Yujia)
%
% file_paths, segments, and assessments have the same index for a given
% student.
function audition_metadata = scanFBA(fba_relative_path, band_option, ...
                                     instrument_option, segment_option, ...
                                     assessment_option, score_option)
                          
% Figure out which students we retrive metadata for.
% student_ids is a N X 1 vector.
student_ids = scanStudentIds(band_option, instrument_option);

% Gather metadata.
file_paths = scanFilePaths(fba_relative_path, student_ids);
segments = scanSegments(segment_option, student_ids);
assessments = scanAssessments(assessment_option, student_ids);
% TODO(Yujia)
score = scanScore(instrument_option, score_option);

% Create the struct.
audition_metadata = struct('file_paths', file_paths, ...
                           'segments', segments, ...
                           'assessments', assessments, ...
                           'score', score);
end