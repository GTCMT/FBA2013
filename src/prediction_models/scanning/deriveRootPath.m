%% Derive path to /predict_models in runtime.
% CL@GTCMT 2015
% root_path: string, relative path from working directory to
%            the /predict_models directory.
%
% This only works for subdirectories of /predict_models.
function root_path = deriveRootPath()
ROOT_DIRECTORY = 'prediction_models';

% Calculate number of subdirectories between the current directory and
% /predict_models. The relative path just goes backwards that many
% directories.
absolute_file_path = pwd();
root_directory_idx = strfind(absolute_file_path, ROOT_DIRECTORY);
sub_path = absolute_file_path(root_directory_idx:end);
num_subdirectories = length(strfind(sub_path, '/'));
root_path = repmat('../', 1, num_subdirectories);
end

