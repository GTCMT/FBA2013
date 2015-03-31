
function merged_note = mergeNotes(left_note, right_note)

% Merge two notes.
merged_note = struct();

merged_note.audio = [left_note.audio; right_note.audio];
merged_note.start = left_note.start;
merged_note.stop = right_note.stop;
merged_note.duration = left_note.duration + right_note.duration;
merged_note.pitches_hz = [left_note.pitches_hz right_note.pitches_hz];
merged_note.mean_pitch_hz = ...
    (left_note.duration * left_note.mean_pitch_hz + ...
     right_note.duration * right_note.mean_pitch_hz) / ...
    (left_note.duration + right_note.duration);

end

