function timbreMeasure =timbreDev(AudioFile,fs)

hop=0.05; % hop in s
frm=0.2; % frm in s
addpath('.\MFCC');
coeff=melfcc(AudioFile,fs, 'maxfreq', 8000, 'numcep', 13, 'nbands', 40, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime',frm, 'hoptime', hop, 'preemph', 0, 'dither', 1);
timbreMeasure=std(coeff,0,2);

end