% Scans the FBA dataset, returning metadata about student auditions. 
% Metadata is returned in the form of a struct, audition_metadata, which is
% described below.
%
%                         %%%% Input %%%%
% fba_relative_path (string): The relative path to the FBA2013 directory 
%                             containing audio files in your computer's 
%                             file system.
% band_option (string): Chooses which band(s) to retrieve auditions for.
% instrument_option (string): Chooses which instruments(s) to retrieve 
%                             auditions for.
% segment_option (string): Chooses which segment(s) of audio to use.
% assessment_option (string): Chooses which assessments to use.
% score_option (bool): Return a score or not.
%
% All options above should return everything if unspecified.
%
%                         %%%% Output %%%%
% audition_metadata.file_paths: The path to each audio file for a student.
% audition_metdata.segments: TODO(Cian)
% audition_metadata.assessments: TODO(Chris)
% audition_metadata.score: TODO(Yujia)
%
% file_paths, segments, and assessments have the same index for a given
% student.
function audition_metadata = scanFBA(fba_relative_path, band_option, ...
                                     instrument_option, segment_option, ...
                                     assessment_option, score_option);
                          
% Figure out which students we retrive metadata for.
% TODO(Cian). student_ids is a N X 1 vector.
student_ids = scanStudentIds(band_option, instrument_option);

% Gather metadata.
% TODO(Chih-Wei)
file_paths = scanFilePaths(fba_relative_path, student_ids);
% TODO(Cian)
segments = scanSegments(segment_option, student_ids);
% TODO(Chris)
assessments = scanAssessments(assessment_option, student_ids);
% TODO(Yujia)
score = scanScore(instrument_option, score_option);

% Create the struct.
audition_metadata = struct('file_paths', file_paths, ...
                           'segments', segments, ...
                           'assessments', assessments, ...
                           'score', score);
                         