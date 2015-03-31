% Time-series harmonics are segmented by note.
%
% harmonics: N*M vector, N -> harmonic index, M -> time
% pitches_hz: M*1 vector, M -> time.
% Fs: sample rate of audio
% hop_size_samples: The number of samples per window
% notes: N*2 cell vector, N -> note index. First index is an M*1 vector
%           of harmonics, 2nd index is a metadata struct. 
% metadata.start: time index of the beginning of the note.
% metadata.stop: time index of the end of the note.
% metadata.pitch_hz: the average pitch of the note.
function notes = noteSegmentation(audio, pitches_hz, Fs, ...
                                     hop_size_samples)
% Notes must be longer than this in order to be used during prediction.
SHORTEST_NOTE_SECONDS = 0.1;
% Number of necessary sequential pitch estimates for a note to be valid.
shortest_note_hops = floor(SHORTEST_NOTE_SECONDS * Fs / hop_size_samples);

% Amount of intonation error where a pitch is still considered the same
% note.
PITCH_ERROR_THRESHOLD_CENTS = 60;

window_size_samples = hop_size_samples;

notes = [];
note_idx = 1;

pitches_hz_smooth = medfilt1(pitches_hz, 7);

% Variables for storing a note.
note_length_windows = 0;
note_start_idx = 1;
average_pitch_hz = -1;
end_of_note = false;

% Windows correspond to pitch estimates.
num_windows = size(pitches_hz_smooth, 2);
window_idx = 1;
while (window_idx <= num_windows)
  
  while(~end_of_note && window_idx <= num_windows)
    cur_pitch = pitches_hz_smooth(window_idx);
    
    % Reject bad pitches.
    if(cur_pitch == -1)
      end_of_note = true;
      break;
    end
    
    % Set average pitch for the first window of a note.
    if(average_pitch_hz == -1)
      average_pitch_hz = cur_pitch;
    end
    
    % Pitch difference between current window pitch and the note pitch.
    num_cents_diff = abs(intervalCents(cur_pitch, average_pitch_hz));
    
    % Current window is accept as part of the current note.
    if(num_cents_diff < PITCH_ERROR_THRESHOLD_CENTS)
      note_length_windows = note_length_windows + 1;
      
      % Add to the average pitch.
      average_coeff = (note_length_windows - 1) / note_length_windows;
      new_coeff = 1 / note_length_windows;
      average_pitch_hz = average_coeff * average_pitch_hz + ...
                      new_coeff * cur_pitch;
                    
      % Move up one window.
      window_idx = window_idx + 1;
      
    % Current window is rejected; end of current note.
    else
      end_of_note = true;
    end
  end
  
  % Only add note to list of notes if it is long enough.
  if(note_length_windows >= shortest_note_hops)
    note_stop_idx = note_start_idx + note_length_windows - 1;
    note_start_samples = (note_start_idx - 1) * hop_size_samples + 1;
    note_stop_samples = (note_stop_idx - 1) * hop_size_samples + ...
                        window_size_samples + 1;
    
    note = struct();
    note.audio = audio(note_start_samples:note_stop_samples);
    note.start = note_start_idx;
    note.stop = note_stop_idx;
    note.mean_pitch_hz = average_pitch_hz;
    note.pitches_hz = pitches_hz_smooth(1, note.start:note.stop);
    notes = [notes; note];
    
    note_idx = note_idx + 1;
  end
  
  % Reset to new note. 
  % This pitch estimate is bad, start next note at next pitch estimate.
  if(cur_pitch == -1)
    note_length_windows = 0;
    average_pitch_hz = -1;
    note_start_idx = window_idx + 1;
    end_of_note = false;
  % The pitch estimate was good, but it was rejected from the previous
  % note. Use this pitch estimate in the next note.
  else
    note_length_windows = 1;
    average_pitch_hz = cur_pitch;
    note_start_idx = window_idx;
    end_of_note = false;
  end
  
  window_idx = window_idx + 1;
end

end

