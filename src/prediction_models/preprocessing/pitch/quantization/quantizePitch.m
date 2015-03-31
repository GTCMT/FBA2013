% Given pitch estimates, quantize them to equal-tempered semitones. The 
% best offset from 440 tuning is selected by doing quantization at
% different offsets and using the offset that gave the smalles root-mean-square
% error.
function pitches_quantized = quantizePitch(pitches_hz)
SEARCH_RANGE_CENTS = 50;
OFFSET_VAL_CENTS = 2;
pitches_quantized = [];
min_error = 10000; % Arbitrarily large.
min_offset = -1; % For debugging.

cur_offset = -1 * SEARCH_RANGE_CENTS;
while(cur_offset <= SEARCH_RANGE_CENTS);
  [cur_pitches, error] = frequencyToMidi(pitches_hz, cur_offset);
  if(error < min_error)
    min_error = error;
    min_offset = cur_offset;
    pitches_quantized = cur_pitches;
  end
  
  cur_offset = cur_offset + OFFSET_VAL_CENTS;
end

end

