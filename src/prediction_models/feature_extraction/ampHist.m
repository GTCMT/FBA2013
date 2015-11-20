%% Amplitude Histogram of Note Segment
% AP@GTCMT, 2015
% amp_hist_feature = ampHist(audio_segment,fs)
% objective: Find uniformity of amplitude within a note segment
%
% INPUTS
% audio_segment: nx1 audio float array, returned by a pitch based note segmentor
%
% OUTPUTS
% amp_hist_feature: kurtosis of the amplitude histogram of a note segment

function amp_hist_feature = ampHist(audio_segment,fs)

% initializations
wSize = 1024; 
hop = 512;
frames = Windows(audio_segment,wSize,hop,fs);

% calculation of frame energy
frame_energy  = sum(abs(fft(frames)));

% computation of amplitude histogram
nbins = 100;
amp_hist = hist(frame_energy, nbins);
amp_hist = smooth(amp_hist);
% plot(amp_hist);
amp_hist_feature = kurtosis(amp_hist);

end
