%% Deviation in the pitch values of the input note
% AV@GTCMT, 2015
% [NoteDeviation]=NoteSteadinessMeasure(pitchvals)
% objective: Find the fluctuation in the input note pitch values
%
% INPUTS
% pitchvals: pitch values in Hz of the segmented note
%
% OUTPUTS
% NoteDeviation: single float values showing standard deviation in terms of
% MIDI notes across the input note

function [NoteDeviation]=NoteSteadinessMeasure(pitchvals)

pitchvalsMidi=69+12*log2(pitchvals/440);
NoteDeviation=std(pitchvalsMidi);

end