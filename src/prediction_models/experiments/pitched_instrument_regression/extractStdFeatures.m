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
%> 13 MFCCs
%>  'SpectralCentroid',
%>  'SpectralCrestFactor',
%>  'SpectralDecrease',
%>  'SpectralFlatness',
%>  'SpectralFlux',
%>  'SpectralKurtosis',
%>  'SpectralMfccs',
%>  'SpectralPitchChroma',
%>  'SpectralRolloff',
%>  'SpectralSkewness',
%>  'SpectralSlope',
%>  'SpectralSpread',
%>  'SpectralTonalPowerRatio',
%>  'TimeAcfCoeff',
%>  'TimeMaxAcf',
%>  'TimePeakEnvelope',
%>  'TimePredictivityRatio',
%>  'TimeRms',
%>  'TimeStd',
%>  'TimeZeroCrossingRate',
function [features] = extractStdFeatures(audio, Fs, wSize, hop)

    FeatureNames={'SpectralCentroid',
  'SpectralCrestFactor',
  'SpectralDecrease',
  'SpectralFlatness',
  'SpectralFlux',
  'SpectralKurtosis',
  'SpectralRolloff',
  'SpectralSkewness',
  'SpectralSlope',
  'SpectralSpread',
  'SpectralTonalPowerRatio',
  %'TimeAcfCoeff',
  %'TimeMaxAcf',
%   'TimePeakEnvelope',
%   'TimePredictivityRatio',
%  'TimeRms',  
%  'TimeStd',
%   'TimeZeroCrossingRate'
};
    features=zeros(1,24);
    nfft=wSize;
    noverlap=wSize-hop;
    
    algo='acf';
    [f0, ~] = estimatePitch(audio, Fs, hop, wSize, algo);    
    note = noteSegmentation(audio, f0, Fs, hop, 50, 0.2 , -50);
    
    % features are extracted at each note level
    for i=1:size(note,1)
            
        [specMat,~,~]=spectrogram(note(i).audio,wSize,noverlap,nfft,Fs);
        [vmfcc(:,i)] = FeatureSpectralMfccs(abs(specMat), Fs);
        for j=1:length(FeatureNames)
            [v(j,i), ~] = ComputeFeature (FeatureNames{j}, note(i).audio, Fs);% wSize, wSize, hop);
        end
    end
    
    % final feature vector is the mean of each feature over all the notes
    features(1,1:13) = mean(vmfcc,2)';
    features(1,14:end)=mean(v,2)';
    
end