%% Amplitude Histogram of Note Segment
% AP@GTCMT, 2015
% amp_hist_feature = ampHist(audio_segment,fs)
% objective: Find uniformity of amplitude within a note segment
%
% INPUTS
% audio_segment: nx1 float array, returned by a pitch based note segmentor
%
% OUTPUTS
% amp_hist_feature: no. of sharp amplitude chages within the note segment

function amp_hist_feature = ampHist(audio_segment,fs)

% initializations
wSize = 1024; 
hop = 512;
frames = Windows(audio_segment,wSize,hop,fs);

% calculation of frame energy
spec_energy  = sum(abs(fft(frames)));

% computation of amplitude histogram
nbins = 100;
amp_hist = hist(spec_energy, nbins);
amp_hist = smooth(amp_hist);
% plot(amp_hist);

amp_hist_feature = kurtosis(amp_hist);
end