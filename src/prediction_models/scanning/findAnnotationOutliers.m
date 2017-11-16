function [outliers_no_seg, outliers_num_seg] = findAnnotationOutliers(BAND_OPTION, INSTRUMENT_OPTION, YEAR_OPTION)

% AP@GTCMT, 2017
% objective: tries to find possible outliers in annotations
%
% INPUTS
% BAND_OPTION: string for one of the three band options we have
% INSTRUMENT_OPTIONS: string for one of the instrument options we have
% YEAR_OPTION: string for one of the year options we have
%
% OUTPUTS
% student_ids: 1xnum_students int, containing student ids


student_ids = scanStudentIds(BAND_OPTION, INSTRUMENT_OPTION, YEAR_OPTION);
segment_filepaths = scanSegmentFilePaths(student_ids, BAND_OPTION, YEAR_OPTION);

a = cellfun(@isempty, segment_filepaths);
outliers_no_seg = student_ids(a);
b = ~cellfun(@isempty, segment_filepaths);
students_with_seg = student_ids(b);
segmentpaths = segment_filepaths(b);

wrong_segments = checkNumSegments(segmentpaths);
outliers_num_seg = students_with_seg(wrong_segments == 1);


%bad_dur = checkDurSegments(segment_filepaths, 2, 3);

end