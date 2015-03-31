function new_notes = noteThinning(notes, min_duration_windows)
new_notes = notes;
num_notes = size(new_notes, 1);

[min_duration, min_idx] = min([new_notes.duration]);
while(min_duration <= min_duration_windows)
  cur_note = new_notes(min_idx);
  
  % Choose which side to merge with.
  note_on_edge = false;
  if(min_idx == num_notes)
    left_idx = min_idx - 1;
    right_idx = min_idx;
    note_on_edge = true;
  elseif(min_idx == 1)
    left_idx = min_idx;
    right_idx = min_idx + 1;
    note_on_edge = true;
  end
  if(~note_on_edge)
    left_pitch = new_notes(min_idx - 1).mean_pitch_hz;
    cur_pitch = cur_note.mean_pitch_hz;
    right_pitch = new_notes(min_idx + 1).mean_pitch_hz;
    if(intervalCents(left_pitch, cur_pitch) < ...
       intervalCents(cur_pitch, right_pitch))
      left_idx = min_idx - 1;
      right_idx = min_idx;
    else
      left_idx = min_idx;
      right_idx = min_idx + 1;
    end
  end

  % Merge two notes.
  left_note = new_notes(left_idx);
  right_note = new_notes(right_idx);
  new_note = mergeNotes(left_note, right_note);
  
  % Update note vector.
  new_notes(left_idx) = new_note;
  new_notes(right_idx) = [];
  num_notes = size(new_notes, 1);

  % Find next minimum pitch difference.
  [min_duration, min_idx] = min([new_notes.duration]);
end

end

