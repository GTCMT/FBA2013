% Segment audio into notes using only pitch information. Pitches are
% smoothed with a median filter, quantized, and boundaries are detected at
% changes in values. Then, adjacent notes whose average pitches
% (unquantized) are within 85 cents are merged together, starting with the
% closest two notes.
function notes = noteSegmentationQuantization(audio, pitches_hz, Fs, ...
                                              hop_size)
% Notes must be longer than this in order to be used during prediction.
MIN_NOTE_WINDOWS = 0.15;
% Number of necessary sequential pitch estimates for a note to be valid.
min_note_windows = floor(MIN_NOTE_WINDOWS * Fs / hop_size);

% Amount of intonation error where a pitch is still considered the same
% note.
PITCH_ERROR_THRESHOLD_CENTS = 85;

window_size_samples = hop_size;
num_windows = size(pitches_hz, 2);

notes = [];
note_idx = 1;

% Smooth pitches.
pitches_hz_smooth = medfilt1(pitches_hz, 7);

% Quantize to semitone.
quantized_pitches = quantizePitch(pitches_hz_smooth);

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
notes = [];
num_notes = size(boundaries) - 1;
for(note_idx = 1:num_notes)
  note_start = ((boundaries(note_idx) - 1) * hop_size) + 1;
  note_stop = ((boundaries(note_idx + 1) - 1) * hop_size) + 1;
  
  note = struct;
  note.audio = audio(note_start:note_stop);
  note.start = boundaries(note_idx);
  note.stop = boundaries(note_idx + 1);
  note.duration = note.stop - note.start + 1;
  note.pitches_hz = pitches_hz_smooth(1, note.start:note.stop);
  note.mean_pitch_hz = mean(note.pitches_hz);
  
  notes = [notes; note];
end

notes = greedyPitchMerge(notes, PITCH_ERROR_THRESHOLD_CENTS);
notes = noteThinning(notes, min_note_windows);

end