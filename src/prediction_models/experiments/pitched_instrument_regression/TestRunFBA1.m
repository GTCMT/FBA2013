close all;
clear all;
clc

% AV@GTCMT
% Objective: extract designed features for segment specified in the for loop for the
% Band option and instrument specified in the variables BAND_OPTION and
% INSTRUMENT_OPTION respectively.
% The getFeatureForSegment function stores the extracted features and their
% labels in the folder 'data' in a mat file named as 'BandOption InstrumentOption SegmentNumber'

BAND_OPTION = 'middle';
INSTRUMENT_OPTION = 'Alto Saxophone';

addpath(pathdef);

for segment = 5
    getFeatureForSegment(BAND_OPTION, INSTRUMENT_OPTION, segment);
end