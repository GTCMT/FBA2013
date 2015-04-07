function getAccuracy(read_file_name)
DATA_PATH = '../../../../data/';
if(exist('read_file_name', 'var'))
  root_path = deriveRootPath();
  full_data_path = [root_path DATA_PATH];
  
  % Check that directory exists.
  if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
  end
else
  error('No file name specified.');
end

load([full_data_path read_file_name]);

end

