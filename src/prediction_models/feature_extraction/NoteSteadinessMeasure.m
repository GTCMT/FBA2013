function [stdDev]=NoteSteadinessMeasure(pitchvals)

pitchvalsMidi=69+12*log2(pitchvals/440);
stdDev=std(pitchvalsMidi);

end