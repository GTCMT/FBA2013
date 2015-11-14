function [features] = extractFeatures(audio, Fs, wSize, hop)

    algo='acf';

    [f0, ~] = estimatePitch(audio, Fs, hop, wSize, algo);
    note = noteSegmentation(audio, f0, Fs, hop, 50, 0.2 , -50);

    features(1,1) = PlayingNotes100CntsHist(f0);

    for i=1:size(note,1)
        a = note(i).pitches_hz;
        b = note(i).audio;
        [stdDev(i)]=NoteSteadinessMeasure(a);

        timbreMeasure(:,i) =timbreDev(note(1).audio,Fs);

        amp_hist_feature(i) = ampHist(b,Fs);

        ampenv_peaks(i) = ampEnvPeaks(b, Fs);
    end
    
    features(1,2)=mean(stdDev);
    features(1,3)=std(stdDev);
    
    features(1,4)=mean(timbreMeasure(1,:));
    features(1,5)=std(timbreMeasure(1,:));
    
    features(1,6)=mean(amp_hist_feature);
    features(1,7)=std(amp_hist_feature);
    
    features(1,8)=mean(ampenv_peaks);
    features(1,9)=std(ampenv_peaks);
end