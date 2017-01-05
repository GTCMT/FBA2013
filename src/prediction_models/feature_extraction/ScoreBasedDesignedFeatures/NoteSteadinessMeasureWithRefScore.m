%% Deviation in the pitch values of the input note from the given midi note
% AV@GTCMT
% [NoteDeviation]=NoteSteadinessMeasureWithRefScore(pitchvals)
% objective: Find the fluctuation in the input note pitch values from the
% given reference midi note
%
% INPUTS
% pitchvals: pitch values in Hz of the segmented note
% midi note: the correct note corresponding to the score
%
% OUTPUTS
% NoteAvgDevFromRef: mean value of notes deviating from the given midi note reference
% NoteAvgStdFromRef: standard deviation of difference between students' playing and expected midi note

function [NoteAvgDevFromRef,NoteStdDevFromRef]=NoteSteadinessMeasureWithRefScore(pitchvals, midiNote)

pitchvalsMidi=69+12*log2(pitchvals/440);

% mean value of notes deviating from the given midi note reference
NoteAvgDevFromRef=mean((abs(pitchvalsMidi-midiNote)));
NoteStdDevFromRef=std((abs(pitchvalsMidi-midiNote)));

end