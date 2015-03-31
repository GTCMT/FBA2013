% Convert frequency to midi note-number, returning the rms error as well.
% The offset uses a tuning away from 440 tuning.
function [midi_pitch, rms_error] = frequencyToMidi(pitch_hz, cents_offset)
  % Reference from A440, which has the MIDI pitch number 69.
  ref_freq = 440;
  ref_midi = 69;
  
  ref_freq = ref_freq * pow2(cents_offset / 1200);
  pitch_hz(pitch_hz == 0) = 0.01;
  midi_pitch_fraction = ref_midi + 12 * log2(pitch_hz / ref_freq);
  midi_pitch = round(midi_pitch_fraction);
  
  error = midi_pitch - midi_pitch_fraction;
  rms_error = sqrt(sum(error .* error));
end
