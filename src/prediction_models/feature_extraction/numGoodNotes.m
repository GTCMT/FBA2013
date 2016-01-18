%% Number of Good Notes in Performance
% AP@GTCMT, 2015
% numGoodNotesFeat = numGoodNotes(notes)
% objective: Compute of % of good notes in a performance based on deviation
% from average pitch
%
% INPUTS
% notes: Nx1 struct containing the note segments
% thresh: percentage of pitch values that do not exceed 1* standard deviation 
%
% OUTPUTS
% numGoodNotesFeat: % of good notes in a performance based on deviation
% from average pitch

function numGoodNotesFeat = numGoodNotes(note,thresh)

numBadNotes = 0;
L = size(note,1);
for i=1:L
    a = note(i).pitches_hz;
    [~, countGreaterStdDev]=NoteSteadinessMeasure(a);
    numBadNotes = numBadNotes + (countGreaterStdDev>thresh);
end

numGoodNotesFeat = 1 - numBadNotes/L;

end
