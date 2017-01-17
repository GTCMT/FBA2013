%% Get score aligned IOI-based features
% Input:
%   IOI: float, N by 1 vector, inter-onset interval in seconds
%   midiScoreMat: float, N by 7 matrix, midi score matrix (see miditoolbox)
% Output:
%   IOI_diff_n: float, M by 1 vector, IOI diff after duration normalization
%   dtw_cost_n: float, scalar, DTW cost normalized by the path length
%   addedNotes: int, scalar, counts of additional notes
%   missingNotes: int, scalar, counts of missing notes
% CW @ GTCMT 2017

function [IOI_score, dtw_cost_n, addedNotes, missingNotes] = getScoreAlignedIoiFeatures(IOI, midiScoreMat)
    % ==== get onsets from MIDI score
    onsetInSec_score = midiScoreMat(:, 6);
    IOI_score = diff(onsetInSec_score);         
    addedNotes = 0;
    missingNotes = 0; 
    % ==== IOI alignment using DTW
    D = pdist2(IOI_score, IOI');
    [path, C] = ToolSimpleDtw(D);
    dtw_cost_n = C(end, end)/length(path);
    %IOI_aligned = zeros(length(IOI_score), 1);
    for jj = 1:length(IOI_score)
        idx = find(path(:, 1) == jj);
        %IOI_aligned(jj) = IOI(path(idx(1), 2));
        if length(idx) > 1
            addedNotes = addedNotes + length(idx) - 1;
        end
    end
    
    %IOI_score_aligned = zeros(length(IOI), 1);
    for kk = 1:length(IOI)
        idx = find(path(:, 2) == kk);
        %IOI_score_aligned(kk) = IOI_score(path(idx(1), 1));
        if length(idx) > 1
            missingNotes = missingNotes + length(idx) - 1;
        end
    end
    
    % ==== visualization
%     % before alignment
%     stem(1:length(IOI), IOI); hold on; stem(1:length(IOI_score), IOI_score); legend('perform', 'score');figure;
%     % after alignment
%     stem(1:length(IOI_aligned), IOI_aligned); hold on; stem(1:length(IOI_score), IOI_score); legend('perform_aligned', 'score');
%     
    % ==== duration normalization 
%     [minIOI_score, minIdx_score] = min(IOI_score);
%     minIOI_aligned = IOI_aligned(minIdx_score);
%     IOI_n = IOI_aligned./minIOI_aligned;
%     IOI_score_n = IOI_score./minIOI_score;
    
    % ==== compute IOI diff after alignment and duration normalization 
%     IOI_diff = abs(IOI_score_aligned(:) - IOI(:));
    
end
