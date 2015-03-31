%% Predict labels using pitch features
% CL@GTCMT 2015
function predictions = pitchFeaturesPredictLabels()
  % Options.
  ROOT_PATH = '../../';
  FBA_RELATIVE_PATH = '../../../../../../dataset/FBA2013';
  BAND_OPTION = 'symphonic';
  INSTRUMENT_OPTION = 'Bb Clarinet';
  SEGMENT_OPTION = [1;2;3;4;5];
  SCORE_OPTION = [];
  HOP_SIZE = 512;
  audition_metadata = scanFBA(ROOT_PATH, FBA_RELATIVE_PATH, ...
                              BAND_OPTION, INSTRUMENT_OPTION, ...
                              SEGMENT_OPTION, SCORE_OPTION);
              
  % One student at a time.
  num_segments = size(SEGMENT_OPTION, 1);
  num_students = size(audition_metadata.file_paths, 1);
  for(student_idx = 1:num_students)
    disp(['Processing student with id: ' num2str(student_idx)]);
    file_name = audition_metadata.file_paths{student_idx};
    segments = audition_metadata.segments{student_idx};
    student_assessments = audition_metadata.assessments{student_idx};
    
    % Retrieve audio for each segment.
    [segmented_audio, Fs] = scanAudioIntoSegments(file_name, segments);
    for(segment_idx = 1:num_segments)
      current_audio = segmented_audio{segment_idx};
      % Use all existing assessments.
      segment_assessments = student_assessments(segment_idx, :);
      segment_assessments = segment_assessments(segment_assessments ~= -1);
      
      pitches = estimatePitch(current_audio, Fs, HOP_SIZE);
      current_notes = ...
          noteSegmentationQuantization(current_audio, pitches, Fs, ...
                                                   HOP_SIZE);
    end
  end
  predictions = 5;
end