function root_path = deriveRootPath()
ROOT_DIRECTORY = 'prediction_models';
absolute_file_path = pwd();
root_directory_idx = strfind(absolute_file_path, ROOT_DIRECTORY);
sub_path = absolute_file_path(root_directory_idx:end);
num_subdirectories = length(strfind(sub_path, '/'));
root_path = repmat('../', 1, num_subdirectories);
end

