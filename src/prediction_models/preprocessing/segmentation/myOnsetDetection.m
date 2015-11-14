%% onset detection with adaptive thresholding
% [onsetTimeInSec] = myOnsetDetection(nvt)
% input: 
%   nvt: N by 1 float vector, input signal
%   
% output: 
%   onsetLocs: n by 1 float vector, onset in samples

function [onsetLocs] = myOnsetDetection(nvt)

order = 18;
lambda = 0.1;
thres = myMedianThres(nvt, order, lambda);
figure; plot(nvt,'r'); hold on;
%plot(thres,'g'); hold off;
delta = nvt - thres;
hwrNvt = delta.*(delta>0); %half-wave rectification
hwrNvt = smooth(hwrNvt); %smoothing
%plot(hwrNvt);
[~,locs] = findpeaks(hwrNvt);
onsetLocs = locs;


end



