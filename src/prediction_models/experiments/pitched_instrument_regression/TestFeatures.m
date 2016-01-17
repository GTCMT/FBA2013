%Code to test the features

clear all;
close all;
clc;

addpath(pathdef);

FileNumber='28610';
% data path on machine
pathchk=['M:\My Documents\FBA2013data\middleschoolscores\' FileNumber '\'];
% pathchk=['/Users/Amruta/Documents/MS GTCMT/GRA work/FBA2013data/concertbandscores/' FileNumber '/'];
[audio,Fs]=audioread([pathchk FileNumber '.mp3']);

for seg =1:5
segments = scanSegments(seg, str2num(FileNumber));

    hop=512; wSize=1024; algo='acf';

    strtsmpl=round(segments{1,1}(1)*Fs);
    endsmpl=round(strtsmpl+segments{1,1}(2)*Fs);

    audio=mean(audio,2);

    [f0, timeInSec] = estimatePitch(audio(strtsmpl:endsmpl), Fs, hop, wSize, algo);
    note = noteSegmentation(audio(strtsmpl:endsmpl), f0, Fs, hop, 50, 0.2 , -50);

    [Feature(seg)]=IOIfeatures (note);
%     PitchRead=[];
%     PitchRead(:,1)=timeInSec;
%     PitchRead(:,2)=f0;
%     goodness_measure(seg) = PlayingNotes100CntsHist(PitchRead);
% 
%     for i=1:size(note,1)
%         a = note(i).pitches_hz;
%         b = note(i).audio;
%         [stdDev(i)]=NoteSteadinessMeasure(a);
% 
%         timbreMeasure(:,i) =timbreDev(note(1).audio,Fs);
% 
%         amp_hist_feature(i) = ampHist(b,Fs);
% 
%         ampenv_peaks(i) = ampEnvPeaks(b, Fs);
%     end
%     
%     NoteSteadinessMeasureMean(seg)=mean(stdDev);
%     NoteSteadinessMeasureDev(seg)=std(stdDev);
%     
%     FinalTimbreMean(seg)=mean(timbreMeasure(1,:));
%     FinalTimbreStdDev(seg)=std(timbreMeasure(1,:));
%     
%     ampHistFeatureMean(seg)=mean(amp_hist_feature);
%     ampHistFeatureStdDev(seg)=std(amp_hist_feature);
%     
%     ampEnvPeaksMean(seg)=mean(ampenv_peaks);
%     ampEnvPeaksStdDev(seg)=std(ampenv_peaks);

%     features=zeros(1,32);
%     algo='acf';
%     algo='acf';
% 
%     [f0, ~] = estimatePitch(audio, Fs, hop, wSize, algo);
%     note = noteSegmentation(audio, f0, Fs, hop, 50, 0.2 , -50);
% 
%     features(1,1) = PlayingNotes100CntsHist(f0);
%     
%     for i=1:size(note,1)
%         a = note(i).pitches_hz;
%         b = note(i).audio;
%         [stdDev(i) countGreaterStdDev(i)]=NoteSteadinessMeasure(a);
%         
%         timbreMeasure(:,i) =timbreDev(note(i).audio,Fs);
% 
%         amp_hist_feature(i) = ampHist(b,Fs);
% 
%         ampenv_peaks(i) = ampEnvPeaks(b, Fs);
%         
%         IOIfeat(i)=IOIfeatures (note(i));
%     end
%     
%     
%     features(1,2)=mean(stdDev);
%     features(1,3)=std(stdDev);
%     features(1,4)=max(stdDev);
%     features(1,5)=min(stdDev);
%     features(1,6)=max(stdDev)-min(stdDev);
%     
%     features(1,7)=mean(countGreaterStdDev);
%     features(1,8)=std(countGreaterStdDev);
%     features(1,9)=max(countGreaterStdDev);
%     features(1,10)=min(countGreaterStdDev);
%     features(1,11)=max(countGreaterStdDev)-min(countGreaterStdDev);
%     
%     features(1,12)=mean(timbreMeasure(2,:)); % take 2nd MFCC
%     features(1,13)=std(timbreMeasure(2,:));
%     features(1,14)=max(timbreMeasure(2,:));
%     features(1,15)=min(timbreMeasure(2,:));
%     features(1,16)=max(timbreMeasure(2,:))-min(timbreMeasure(2,:));
%     
%     features(1,17)=mean(amp_hist_feature);
%     features(1,18)=std(amp_hist_feature);
%     features(1,19)=max(amp_hist_feature);
%     features(1,20)=min(amp_hist_feature);
%     features(1,21)=max(amp_hist_feature)-min(amp_hist_feature);
%     
%     features(1,22)=mean(ampenv_peaks);
%     features(1,23)=std(ampenv_peaks);
%     features(1,24)=max(ampenv_peaks);
%     features(1,25)=min(ampenv_peaks);
%     features(1,26)=max(ampenv_peaks)-min(ampenv_peaks);
%     
%     features(1,27) = numGoodNotes(note);
%     
%     features(1,28)=mean(IOIfeat);
%     features(1,29)=std(IOIfeat);
%     features(1,30)=max(IOIfeat);
%     features(1,31)=min(IOIfeat);
%     features(1,32)=max(IOIfeat)-min(IOIfeat);
end