close all;
clear all;
clc

BAND_OPTION = 'middle';
INSTRUMENT_OPTION = 'Oboe';

addpath(pathdef);

for i = 1:4
    getFeatureForSegment(BAND_OPTION, INSTRUMENT_OPTION, i);
end