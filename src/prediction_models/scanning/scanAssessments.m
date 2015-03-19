%% Scan assessments
% CL@GTCMT 2015
% assessments = scanAssessments(assessment_option, student_ids)
% Return the assessments for each student, read from the *_assessments.txt
% file.
% assessment_option = N*2 int vector, N -> assessments per student, 
%                     1st column = segment, 2nd column = category. 
%                     See /FBA2013/README.txt for index values. ex: for
%                     technical etude tone quality and note accuracy, use
%                     [2 6; 2 4].
% student_ids = N*1 int vector of student ids.
% assessments = N*1 cell vector, each cell is a m*1 vector
%               N -> student_id's, m -> assessments, order taken from 
%               assessment_option, -1 indicates missing assessment.

function assessments = scanAssessments(assessment_option, student_ids)

NUM_SEGMENTS = 10; % Rows.
NUM_CATEGORIES = 26; % Columns.

annotation_path = '../../../FBA2013';
num_students = length(student_ids);
num_assessments = size(assessment_option, 1);
assessments = cell(num_students,1);

for (student_idx = 1:num_students)
  % Create file path.
  current_id = num2str(student_ids(student_idx));
  
  % Search all bands for student.
  found_student = false;
  for (band_idx = 1:3)
    switch (band_idx)
      case 1 
        band_folder = '/concertbandscores';
      case 2
        band_folder = '/middleschoolscores';
      case 3
        band_folder = '/symphonicbandscores';
    end
    file_name = strcat('/', current_id, '_', 'assessments.txt'); 
    file_path = strcat(annotation_path, band_folder, '/', current_id, file_name);

    % Read assessment file.
    if (exist(file_path, 'file') == 2)
      all_current_assessments = dlmread(file_path, ' ', ...
                                    [1 0 NUM_SEGMENTS NUM_CATEGORIES-1]);
      current_assessments = ones(num_assessments,1) * -1;
      for(assessment_idx = 1:num_assessments)
        row_idx = assessment_option(assessment_idx, 1);
        column_idx = assessment_option(assessment_idx, 2);
        current_assessments(assessment_idx) = ...
            all_current_assessments(row_idx, column_idx);
      end
      
      assessments{student_idx} = current_assessments;
      found_student = true;
      continue;
    end
  end
  
  if (~found_student)
    warning(['Could not find student with id: ' num2str(current_id) '.']);
  end
  
end
end