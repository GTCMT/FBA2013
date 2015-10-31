%% AutoCorrelation Calculation for ACF pitch extraction
% AP@GTCMT, 2015
% f0 = autoCorr(frame,fs)
% objective: Calculate auto-correlation of a audio frame 
%
% INPUTS
% frame: wSizex1 float array, single frame of audio signal where wSize is
%        the window Size
% fs: sampling frequency
%
% OUTPUTS
% f0: fundamental frequency of the frame in Hz

function f0 = autoCorr(frame,fs)

% Initialization
wSize = length(frame);
autoCorrelation = zeros(1,wSize); %initialize autocorrelation matrix
i = 1;

% centre clipping
threshold = 0.001;
frame(abs(frame)<threshold) = 0;

while(i<=wSize);
    frameShifted = [zeros(i,1);frame(1:wSize-i)];
    autoCorrelation(i) = sum(frame.*frameShifted);
    i = i+1;
end

maxOffset = round(fs/100); % considering 100Hz as lower freq
minOffset = round(fs/1000); % considering 1000Hz as higher freq

autoCorrelation = smooth(autoCorrelation,'loess');
% find 1st minimum to further narrow down search region
[~, indmin] = findpeaks(-autoCorrelation);
if(minOffset<=indmin(1) && indmin(1)+3<maxOffset )
    minOffset = indmin(1);
end

[maxima, indmax] = findpeaks(autoCorrelation(minOffset:maxOffset));

if (isempty(maxima) == 1)
   [maxima, indmax] = max(autoCorrelation(minOffset:maxOffset));
end
[~,ind1] = max(maxima);
idx1 = indmax(ind1)+minOffset-1;
f0 = fs/idx1;


end