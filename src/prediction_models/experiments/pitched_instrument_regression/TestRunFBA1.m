close all;
clear all;
clc

BAND_OPTION = 'middle';
INSTRUMENT_OPTION = 'Trumpet';

addpath(pathdef);

for i = 1:5
    getFeatureForSegment(BAND_OPTION, INSTRUMENT_OPTION, i);
end