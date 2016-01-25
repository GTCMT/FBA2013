% Test bag of features

close all;
clear all;
clc

BAND_OPTION = 'middle';
INSTRUMENT_OPTION = 'Oboe';

addpath(pathdef);

for i = 1:4
    getStdFeaturesForSegment(BAND_OPTION, INSTRUMENT_OPTION, i);
end