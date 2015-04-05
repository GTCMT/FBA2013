%% Predict labels using pitch features
% CL@GTCMT 2015
function predictions = createTrainingData(write_file_name)
  DATA_PATH = '';
  
  NUM_FEATURES = 3;
  NUM_LABELS = 1;
  QUICK_AND_DIRTY = true;
  
  % Scanning Options.
  ROOT_PATH = '../../';
  FBA_RELATIVE_PATH = '../../../../../../dataset/FBA2013';
  BAND_OPTION = 'symphonic';
  INSTRUMENT_OPTION = 'Bb Clarinet';
  SEGMENT_OPTION = 1;
  SCORE_OPTION = [];
  
  audition_metadata = scanFBA(ROOT_PATH, FBA_RELATIVE_PATH, ...
                              BAND_OPTION, INSTRUMENT_OPTION, ...
                              SEGMENT_OPTION, SCORE_OPTION);
  
  assessments = audition_metadata.assessments{1};
  assessments = assessments(1, :);
  assessments = assessments(assessments ~= -1);
  num_labels = size(assessments, 2)
  num_students = size(audition_metadata.file_paths, 1); 
  
  if(QUICK_AND_DIRTY)
    num_students = 20;
  end
  
  training_features = zeros(num_students, NUM_FEATURES);
  training_labels = zeros(num_students, num_labels);
                
  % One student at a time.
  for(student_idx = 1:num_students)
    disp(['Processing student with id: ' num2str(student_idx)]);
    file_name = audition_metadata.file_paths{student_idx};
    segments = audition_metadata.segments{student_idx};
    student_assessments = audition_metadata.assessments{student_idx};
    
    % Retrieve audio for each segment.
    [segmented_audio, Fs] = scanAudioIntoSegments(file_name, segments);
    
    current_audio = segmented_audio{1};
      
    % Normalize audio;
    normalized_audio = mean(current_audio, 2);
    normalized_audio = normalized_audio ./ max(abs(normalized_audio));

    training_features(student_idx, :) = ...
        extractPitchFeatures(normalized_audio);

    % Use all existing assessments.
    segment_assessments = student_assessments(1, :);
    segment_assessments = segment_assessments(segment_assessments ~= -1);

    training_labels(student_idx, :) = segment_assessments;
  end
end