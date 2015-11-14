%Code to test the features

clear all;
close all;
clc;

FileNumber='28766';
pathchk=['/Users/Amruta/Documents/MS GTCMT/GRA work/FBA2013data/concertbandscores/' FileNumber '/'];
[audio,Fs]=audioread([pathchk FileNumber '.mp3']);

for seg =1:5
segments = scanSegments(seg, str2num(FileNumber));

    hop=512; wSize=1024; algo='acf';

    strtsmpl=round(segments{1,1}(1)*Fs);
    endsmpl=round(strtsmpl+segments{1,1}(2)*Fs);

    audio=mean(audio,2);

    [f0, timeInSec] = estimatePitch(audio(strtsmpl:endsmpl), Fs, hop, wSize, algo);
    note = noteSegmentation(audio(strtsmpl:endsmpl), f0, Fs, hop, 50, 0.2 , -50);

% [nvt] = myWPD(audio(strtsmpl:endsmpl), wSize, hop,Fs);
% [onsetLocs] = myOnsetDetection(nvt);
    PitchRead=[];
    PitchRead(:,1)=timeInSec;
    PitchRead(:,2)=f0;
    goodness_measure(seg) = PlayingNotes100CntsHist(PitchRead);

    for i=1:size(note,1)
        a = note(i).pitches_hz;
        b = note(i).audio;
        [stdDev(i)]=NoteSteadinessMeasure(a);

        timbreMeasure(:,i) =timbreDev(note(1).audio,Fs);

        amp_hist_feature(i) = ampHist(b,Fs);

        ampenv_peaks(i) = ampEnvPeaks(b, Fs);
    end
    
    NoteSteadinessMeasureMean(seg)=mean(stdDev);
    NoteSteadinessMeasureDev(seg)=std(stdDev);
    
    FinalTimbreMean(seg)=mean(timbreMeasure(1,:));
    FinalTimbreStdDev(seg)=std(timbreMeasure(1,:));
    
    ampHistFeatureMean(seg)=mean(amp_hist_feature);
    ampHistFeatureStdDev(seg)=std(amp_hist_feature);
    
    ampEnvPeaksMean(seg)=mean(ampenv_peaks);
    ampEnvPeaksStdDev(seg)=std(ampenv_peaks);
end