% Merge adjacent notes where difference in average pitch < THRESHOLD, in
% order of lowest difference.
function new_notes = greedyPitchMerge(notes, pitch_error_threshold_cents)
num_notes = size(notes, 1);
new_notes = notes;

pitch_difference_cents = zeros(num_notes - 1, 1);  % Index corresponds to smaller index in note-pair.
for(note_idx = 1:num_notes - 1)
  left_note = new_notes(note_idx);
  right_note = new_notes(note_idx + 1);
  cur_pitch_difference = abs(intervalCents(left_note.mean_pitch_hz, ...
                                           right_note.mean_pitch_hz));
  pitch_difference_cents(note_idx) = cur_pitch_difference;
end

[min_difference, min_idx] = min(pitch_difference_cents);
while(min_difference <= pitch_error_threshold_cents)
  left_note = new_notes(min_idx);
  right_note = new_notes(min_idx + 1);
  
  % Merge two notes.
  new_note = mergeNotes(left_note, right_note);
  
  % Update note vector.
  new_notes(min_idx) = new_note;
  new_notes(min_idx + 1) = [];
  num_boundaries = size(pitch_difference_cents, 1);
  
  % Update note differences.
  for(boundary_idx = min_idx-1:min_idx)
    % Bounds check.
    if(boundary_idx >=1 && boundary_idx + 1 <= num_boundaries)
      left_pitch = new_notes(boundary_idx).mean_pitch_hz;
      right_pitch = new_notes(boundary_idx + 1).mean_pitch_hz;
      cur_pitch_difference = ...
        abs(intervalCents(left_pitch, right_pitch));
      pitch_difference_cents(boundary_idx) = cur_pitch_difference;
    end
  end
  
  if(min_idx < num_boundaries)
    pitch_difference_cents(min_idx + 1) = [];
  elseif(min_idx == num_boundaries)
    pitch_difference_cents(min_idx) = [];
  end
  
  % Find next minimum pitch difference.
  [min_difference, min_idx] = min(pitch_difference_cents);
end

end

