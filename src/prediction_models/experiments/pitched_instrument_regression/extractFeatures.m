%% Feature vector creation
% AV@GTCMT and AP@GTCMT, 2015
% [features] = extractFeatures(audio, Fs, wSize, hop)
% objective: Create a feature vector of all the features called inside this
% function
%
% INPUTS
% audio: samples
% Fs: sampling frequency
% wSize: window size in samples
% hop: hop in samples
%
% OUTPUTS
% features: 1 x N feature vector (where N is the number of features getting extracted in the function)

function [features] = extractFeatures(audio, Fs, wSize, hop)

    algo='acf';

    [f0, ~] = estimatePitch(audio, Fs, hop, wSize, algo);
    note = noteSegmentation(audio, f0, Fs, hop, 50, 0.2 , -50);

    features(1,1) = PlayingNotes100CntsHist(f0);
    
    for i=1:size(note,1)
        a = note(i).pitches_hz;
        b = note(i).audio;
        [stdDev(i) countGreaterStdDev(i)]=NoteSteadinessMeasure(a);
        
        timbreMeasure(:,i) =timbreDev(note(1).audio,Fs);

        amp_hist_feature(i) = ampHist(b,Fs);

        ampenv_peaks(i) = ampEnvPeaks(b, Fs);
    end
    
    
    features(1,2)=mean(stdDev);
    features(1,3)=std(stdDev);
    features(1,4)=max(stdDev);
    features(1,5)=min(stdDev);
    features(1,6)=max(stdDev)-min(stdDev);
    
    features(1,7)=mean(countGreaterStdDev);
    features(1,8)=std(countGreaterStdDev);
    features(1,9)=max(countGreaterStdDev);
    features(1,10)=min(countGreaterStdDev);
    features(1,11)=max(countGreaterStdDev)-min(countGreaterStdDev);
    
    features(1,12)=mean(timbreMeasure(2,:)); % take 2nd MFCC
    features(1,13)=std(timbreMeasure(2,:));
    features(1,14)=max(timbreMeasure(2,:));
    features(1,15)=min(timbreMeasure(2,:));
    features(1,16)=max(timbreMeasure(2,:))-min(timbreMeasure(2,:));
    
    features(1,17)=mean(amp_hist_feature);
    features(1,18)=std(amp_hist_feature);
    features(1,19)=max(amp_hist_feature);
    features(1,20)=min(amp_hist_feature);
    features(1,21)=max(amp_hist_feature)-min(amp_hist_feature);
    
    features(1,22)=mean(ampenv_peaks);
    features(1,23)=std(ampenv_peaks);
    features(1,24)=max(ampenv_peaks);
    features(1,25)=min(ampenv_peaks);
    features(1,26)=max(ampenv_peaks)-min(ampenv_peaks);
    
    features(1,27) = numGoodNotes(note);
    
end