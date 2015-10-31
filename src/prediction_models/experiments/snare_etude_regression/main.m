%% snare drum etude regression experiment
% CW @ GTCMT 2015

clear all; clc; close all;

cd ../../scanning/

fba_relative_path = '../../FBA2013';
band_option = 'middle'; %'concert', 'symphonic'
instrument_option = 'Percussion';
segment_option = [2];
score_option = [];

audition_metadata = scanFBA(fba_relative_path, ...
    band_option, ...
    instrument_option, ...
    segment_option, ...
    score_option);

cd ../experiments/snare_etude_regression/