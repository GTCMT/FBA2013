clear all;
close all;
clc;

addpath(pathdef);

DATA_PATH = 'experiments\pitched_instrument_regression\data_acf_altosax\';
write_file_name = 'middleAlto Saxophone2';

% Check for existence of path for writing extracted features.
  root_path = deriveRootPath();
  full_data_path = [root_path DATA_PATH];
  
  if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
  end
  
NUM_FOLDS = 122;
load([full_data_path write_file_name]);

labels = labels(:,1);

[~,NumFeat]=size(features);

v={[];};
v{NumFeat}=[];
f='f';
FS=struct(f,v);
FScorr=FS;
FSp=FS;
FSs=FS;
FSrsq=FS;
CorrArr=[];
PValArr=[];

for i=1:NumFeat
    FS(i).f=combntns(1:NumFeat,i);
end

for i=1:NumFeat
    [rw,cl]=size(FS(i).f);
    for iter=1:rw
        [FSrsq(i).f(iter), FSs(i).f(iter), FSp(i).f(iter), FScorr(i).f(iter)]=crossValidation(labels, features(:,FS(i).f(rw,:)),NUM_FOLDS);
        CorrArr=[CorrArr;FScorr(i).f(iter)];
        PValArr=[PValArr;FSp(i).f(iter)];
    end
    
end

save('ExhaustiveFeatrSelect.mat');


