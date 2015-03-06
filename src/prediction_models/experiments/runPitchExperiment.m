% Example code for a fake experiment that predicts correctness based on
% pitch tracking for concert band in the techincal etude section.
function runPitchExperiment(f0)

BAND = 'Concert'; % 'Middle' 'Symphonic'.
SEGMENTS = 'Technical_Etude';
ASSESSMENT = 'Correctness'; 
N_FOLD = 10; % For cross validation.

% Read in audio.
[audio, labels, Fs] = scanFBA(BAND, SEGMENTS, ASSESSMENT);
cutoff = Fs / 4; % Lowpass cutoff frequency.

num_data = size(audio, 1);
features = []; 

for(i = 1:num_data);
  % Preprocessing.  
  audio(i) = lowPass(audio(i), Fs, cutoff);
  
  % Feature Extraction.
  cur_feature = extractFeaturesPitch(audio, Fs, f0);
  features = [features; cur_feature]; % Slow, too much copying...
  
  % Postprocessing.
  features = meanFeatures(features);
end

crossValidate(features, labels, n_fold, 'libsvm');
end