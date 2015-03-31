function [notes, Fs] = segmentByAmplitude(cur_filename)
HIGH_THRESHOLD = 0.001;
LOW_THRESHOLD = 0.0001;
WINDOW_SIZE = 1024;
HOP_SIZE = 1024;
SHORTEST_NOTE_TIME = 0.4;
WINDOWS_BEFORE = 6;

[audio, Fs] = audioread(cur_filename);
N = size(audio, 1);
SHORTEST_NOTE_WINDOWS = floor(Fs * SHORTEST_NOTE_TIME / WINDOW_SIZE);

mono_audio = mean(audio, 2);
onsets = [];
segments = [];
note_on = false;

num_segments = 0;
start = 1;
stop = start + WINDOW_SIZE - 1;
window_idx = 1;
while(stop <= N);
  window = mono_audio(start:stop);
  rms_amplitude = sum(abs(window)) / WINDOW_SIZE;
  
  if(note_on)
    threshold = LOW_THRESHOLD;
  else
    threshold = HIGH_THRESHOLD;
  end
  
  if(rms_amplitude > threshold)
    current_onset = 1;
    
    if(~note_on)
      if(num_segments == 0)
        segments = [segments; window_idx];
        num_segments = num_segments + 1;
      elseif(window_idx - segments(num_segments) > SHORTEST_NOTE_WINDOWS)
        segments = [segments; window_idx];
        num_segments = num_segments + 1;
      end
    end
    note_on = true;
  else
    current_onset = 0;
    note_on = false;
  end
  onsets = [onsets; current_onset];
  
  start = start + HOP_SIZE;
  stop = start + WINDOW_SIZE - 1;
  window_idx = window_idx + 1;
end

notes = cell(num_segments,1);
for(note_idx = 1:num_segments - 1)
  cur_start_window = segments(note_idx) - WINDOWS_BEFORE;
  cur_end_window = segments(note_idx + 1) - WINDOWS_BEFORE;
  
  cur_start_samples = cur_start_window * WINDOW_SIZE;
  if (cur_start_samples <=0)
    cur_start_samples = 1;
  end
  cur_end_samples = cur_end_window * WINDOW_SIZE;

  notes{note_idx} = audio(cur_start_samples:cur_end_samples, :);
end
last_start_samples = (segments(num_segments) - WINDOWS_BEFORE) * ...
                     WINDOW_SIZE;
notes{num_segments} = audio(last_start_samples:end,:);

% for(note_idx = 1:num_segments - 1)
%   cur_note = notes{ note_idx };
%   plot(cur_note);
%   cur_note;
% end

end
