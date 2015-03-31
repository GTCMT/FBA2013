% Estimate pitch (monophonic) from an audio signal.
% 
% audio: The mono signal.
% Fs: The sample rate.
% hop_size_samples: The number of samples between each pitch estimation.
function pitches = estimatePitch(audio, Fs, hop_size_samples)
INTERNAL_HOP_SIZE_SAMPLES = 128;
num_merge_windows = hop_size_samples / INTERNAL_HOP_SIZE_SAMPLES;

if(ceil(num_merge_windows) ~= floor(num_merge_windows))
  warning(['Chosen hop size (' num2str(hop_size_samples) ') must be a ' ...
           'multiple of the internal hop size (' ...
            num2str(INTERNAL_HOP_SIZE_SAMPLES) ').']);
end

% Set yin options.
YIN_OPTIONS = struct();
YIN_OPTIONS.sr = Fs;
YIN_OPTIONS.hop = INTERNAL_HOP_SIZE_SAMPLES;

% The yin algorithm results. Nan's replaced with 0's.
YIN_RESULT = yin(audio, YIN_OPTIONS);

% Convert to hertz
yin_pitches = pow2(YIN_RESULT.f0) .* 440;

yin_pitches(isnan(yin_pitches)) = 0;

% Merge internal windows into external windows. Pitch becomes median of 
% short-time values.
num_windows = floor(size(yin_pitches, 2) / num_merge_windows);
pitches = zeros(1, num_windows);
merge_start = 1;
merge_stop = merge_start + num_merge_windows - 1;
for(window_idx = 1:num_windows)
  pitches(window_idx) = median(yin_pitches(merge_start:merge_stop));
  merge_start = merge_start + num_merge_windows;
  merge_stop = merge_start + num_merge_windows - 1;
end

end

