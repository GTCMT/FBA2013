close all;
clear all;
clc

BAND_OPTION = 'middle';
INSTRUMENT_OPTION = 'Alto Saxophone';

addpath(pathdef);

for i = 5
    getFeatureForSegment(BAND_OPTION, INSTRUMENT_OPTION, i);
end