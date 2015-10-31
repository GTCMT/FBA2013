clear all;
clc;

tic
addpath('C:\Users\amrut_000\Documents\MS GTCMT\GRA work\FBA2013\src\prediction_models\preprocessing\pitch');
audiopathLoc='C:\Users\amrut_000\Documents\MS GTCMT\GRA work\FBA2013data\concertbandscores\28576';

[audio,Fs]=audioread([audiopathLoc '\28576.mp3']);

addpath('C:\Users\amrut_000\Documents\MS GTCMT\GRA work\FBA2013\src\prediction_models\scanning');
segments = scanSegments(1, 28576);

hop=512; wSize=1024; algo='acf';

strtsmpl=round(segments{1,1}(1)*Fs);
endsmpl=round(strtsmpl+segments{1,1}(2)*Fs);

audio=mean(audio,2);

[f0, timeInSec] = estimatePitch(audio(strtsmpl:endsmpl), Fs, hop, wSize, algo);
PitchRead(:,1)=timeInSec;
PitchRead(:,2)=f0;
goodness_measure = PlayingNotes100CntsHist(PitchRead);

display('Done');
toc