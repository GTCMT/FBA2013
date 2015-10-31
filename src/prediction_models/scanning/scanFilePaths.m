function [file_paths] = scanFilePaths(fba_relative_path, student_ids)
%SCANFILEPATHS Return the path to the audio file for each student id.
% 
% Input:
%   fba_relative_path (string): path to audio files.
%   student_ids (N-by-1 vector): vector of student Ids.
% 
% Output:
%   file_paths: N-by-1 cell array of strings containing audio file paths.
% 
% Assumes the audio files are contained in 3 folders: 
%   'concertbandscores/student_id/student_id.mp3'
%   'middleschoolscores/student_id/student_id.mp3'
%   'symphonicbandscores/student_id/student_id.mp3'

folder_concert      = [fba_relative_path '/concertbandscores'];
folder_middle       = [fba_relative_path '/middleschoolscores'];
folder_symphonic    = [fba_relative_path '/symphonicbandscores'];

N           = size(student_ids,1);
file_paths  = cell(size(student_ids));

for i = 1:N
    
    % see if the folder for this id exists:
    if exist([folder_concert '/' num2str(student_ids(i))]) == 7
        file_paths{i} = [folder_concert '/' num2str(student_ids(i)) '/' num2str(student_ids(i)) '.mp3'];
        
    elseif exist([folder_middle '/' num2str(student_ids(i))]) == 7
        file_paths{i} = [folder_middle '/' num2str(student_ids(i)) '/' num2str(student_ids(i)) '.mp3'];
        
	elseif exist([folder_symphonic '/' num2str(student_ids(i))]) == 7
        file_paths{i} = [folder_symphonic '/' num2str(student_ids(i)) '/' num2str(student_ids(i)) '.mp3'];
        
    else
        disp(['File not found, id: ' num2str(student_ids(i)) '.']);
    end

end