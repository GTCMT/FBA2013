% Segment audio into notes using only pitch information. Pitches are
% smoothed with a median filter, quantized, and boundaries are detected at
% changes in values. Then, adjacent notes whose average pitches
% (unquantized) are within 85 cents are merged together, starting with the
% closest two notes.
function notes = noteSegmentation(audio, pitches_hz, Fs, hop_size, ...
                                  INTERVAL_THRESH_CENTS, ...
                                  MIN_NOTE_SECONDS, POWER_THRESH_DB)
% Number of necessary sequential pitch estimates for a note to be valid.
min_note_windows = floor(MIN_NOTE_SECONDS * Fs / hop_size);
num_windows = size(pitches_hz, 2);

% Smooth pitches.
pitches_hz_smooth = medfilt1(pitches_hz, 5);

% Quantize to semitone.
quantized_pitches = quantizePitch(pitches_hz_smooth);

disp('Getting boundaries');
% Find note boundaries.
boundaries = [];
past_pitch = -1;
for(window_idx = 1:num_windows)
  cur_pitch = quantized_pitches(window_idx);
  if(past_pitch ~= cur_pitch)
    boundaries = [boundaries; window_idx];
  end
end

% Derive notes from boundaries.
num_notes = size(boundaries, 1) - 1;
notes(num_notes) = struct();
notes = notes.';
for(note_idx = 1:num_notes)
  note_start_idx = boundaries(note_idx);
  note_stop_idx = boundaries(note_idx + 1);
  note_start = ((boundaries(note_idx) - 1) * hop_size) + 1;
  note_stop = ((boundaries(note_idx + 1) - 1) * hop_size) + 1;
  cur_pitches_hz = pitches_hz_smooth(1, note_start_idx:note_stop_idx);

  notes(note_idx).audio = audio(note_start:note_stop);
  notes(note_idx).start = note_start_idx;
  notes(note_idx).stop = note_stop_idx;
  notes(note_idx).duration = note_stop_idx - note_start_idx + 1;
  notes(note_idx).pitches_hz = cur_pitches_hz;
  notes(note_idx).mean_pitch_hz = mean(cur_pitches_hz);
end

notes = greedyPitchMerge(notes, INTERVAL_THRESH_CENTS);
notes = noteThinning(notes, min_note_windows);

% Remove notes below a power threshold.
old_notes = notes;
notes = [];
num_notes = size(old_notes, 1);
for (note_idx = 1:num_notes)
  note = old_notes(note_idx);
  note_power = mean(abs(note.audio));
  note_power = note_power * note_power;
  note_power_db = 10 * log10(note_power / 1);
  if(note.duration > min_note_windows && note_power_db > POWER_THRESH_DB)
    notes = [notes; note];
  end
end

end