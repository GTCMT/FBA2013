function [durfeats] = DurHistScore(midi_mat_aligned, note_indices, note_onsets,fs)
% function [durfeats] = DurHistScore(midi_mat)
% Computes duration histogram features
% of the score.
% Args: midi_mat_aligned(output of alignScore), 
%       note_indices(output of computeNoteOccurences),
%       note_onsets (onsets of inserted notes obtained
%                   using alignScore)
%       fs (Sampling feature)
% Output: duration features of first and 
%                   second most occuring notes (10 dimensional)

%pre-process midi_mat_aligned and remove the insertions
for i=1:length(note_onsets)
    ins_note_index = note_onsets(i);
    midi_mat_aligned = [midi_mat_aligned(1:ins_note_index,:); midi_mat_aligned(ins_note_index+2:end,:)];
end


note1_indices = note_indices{1};
note2_indices = note_indices{2};

%Get corresponding note occurences of note 1&2 from student's performance
student_note1 = midi_mat_aligned(note1_indices, 7);
student_note2 = midi_mat_aligned(note2_indices, 7);


% Compute Histogram
edge_list = 0.5:1:10.5;
h1 = histcounts(student_note1, edge_list);
h2 = histcounts(student_note2, edge_list);

% Normalize Histogram
h1_norm = h1/sum(h1);
h2_norm = h2/sum(h1);

%durfeats
skew1 = FeatureSpectralSkewness(h1_norm', fs);
kurto1 = FeatureSpectralKurtosis(h1_norm', fs);
rolloff1 = FeatureSpectralRolloff(h1_norm', fs, 0.85);
flatness1 = FeatureSpectralFlatness(h1_norm', fs);
tonalPower1 = FeatureSpectralTonalPowerRatio(h1_norm', fs);

skew2 = FeatureSpectralSkewness(h2_norm', fs);
kurto2 = FeatureSpectralKurtosis(h2_norm', fs);
rolloff2 = FeatureSpectralRolloff(h2_norm', fs, 0.85);
flatness2 = FeatureSpectralFlatness(h2_norm', fs);
tonalPower2 = FeatureSpectralTonalPowerRatio(h2_norm', fs);

durfeats = [skew1;kurto1;rolloff1;flatness1;tonalPower1;...
    skew2;kurto2;rolloff2;flatness2;tonalPower2];
end