%% Feature vector creation
% AV@GTCMT
% [features] = extractScoredFeatures(audio, Fs, wSize, hop)
% objective: Create a feature vector of all the non score based features called inside this
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

function [features] = extractScoredFeatures(audio, Fs, wSize, hop, YEAR_OPTION)

if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end

features=zeros(1,15);
algo='acf';
timeStep = hop/Fs;

[f0, ~] = estimatePitch(audio, Fs, hop, wSize, algo);

% get the score to pass to the feature extraction function
root_path = deriveRootPath();
scorePath = [root_path '..' slashtype '..' slashtype 'FBA' YEAR_OPTION slashtype 'midiscores' slashtype 'Alto Sax' slashtype 'Middle School' slashtype 'mid_alto_tech_' YEAR_OPTION '.mid'];
scoreMid = readmidi(scorePath);
[rwSc, clSc] = size(scoreMid);

[tfCompnstdF0, flag] = findTuningFrequency(f0);
if flag == 0
    [algndmid, note_onsets, dtw_cost, path] = alignScore(scorePath, tfCompnstdF0, audio, Fs, wSize, hop);
    [slopedev, ~] = slopeDeviation(path);
    [rwStu, clStu] = size(algndmid);
    
    % features over each individual note and then its derived statistical features
    NoteAvgDevFromRef = zeros(1,rwStu); NoteStdDevFromRef = zeros(1,rwStu); NormCountGreaterStdDev = zeros(1,rwStu);
    for i=1:rwStu
        strtTime = round(algndmid(i,6)/timeStep);
        endTime = round(algndmid(i,6)/timeStep + algndmid(i,7)/timeStep + 1);
        pitchvals=(tfCompnstdF0(strtTime:endTime));
        [NoteAvgDevFromRef(1,i),NoteStdDevFromRef(1,i),NormCountGreaterStdDev(1,i)]=NoteSteadinessMeasureWithRefScore(pitchvals(pitchvals~=0), algndmid(i,4));
    end
    
    features(1,1) = abs(rwSc-rwStu);  % difference between the number of notes in the score and the student (inserted notes)
    features(1,2)=mean(NoteAvgDevFromRef);
    features(1,3)=std(NoteAvgDevFromRef);
    features(1,4)=max(NoteAvgDevFromRef);
    features(1,5)=min(NoteAvgDevFromRef);

    features(1,6)=mean(NoteStdDevFromRef);
    features(1,7)=std(NoteStdDevFromRef);
    features(1,8)=max(NoteStdDevFromRef);
    features(1,9)=min(NoteStdDevFromRef); 

    features(1,10)=mean(NormCountGreaterStdDev);
    features(1,11)=std(NormCountGreaterStdDev);
    features(1,12)=max(NormCountGreaterStdDev);
    features(1,13)=min(NormCountGreaterStdDev);

    features(1,14)=dtw_cost;
    features(1,15)=slopedev;
%     features(1,16)=std(ampenv_peaks);
end
      
end