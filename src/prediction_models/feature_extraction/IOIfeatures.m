%% Interonset Interval feature
% AV@GTCMT, 2015
% [Feature]=IOIfeatures (note)
% Objective: To find the number of deviations in the interonset interval
% across several notes
%
% INPUT: 
% note: Nx1 struct array of notes, the segmented notes.
%
% OUTPUT:
% Feature: float value corresponding to fluctuations in the IOI > std dev
% across number of notes specified by noNotes variable. Lower the value,
% better the performer

function [Feature]=IOIfeatures (note)

if isempty(note)~=1
noNotes=10;
IOIdur=zeros(noNotes-1,1);
extraNotes=mod(length(note),noNotes);
cnt=0;
idx=0;
for i= 1:noNotes:length(note)-extraNotes
    for j=i:i+noNotes-2
        strt1 = note(j).start;
        strt2 = note(j+1).start;
        
        idx=idx+1;
        IOIdur(idx) = strt2-strt1;
    end
    stdIOIdur=std(IOIdur);
    cnt=cnt+1;
    OutOfRangeStd(cnt)=sum(abs(IOIdur-mean(IOIdur))>stdIOIdur)/(noNotes-1);
    idx=0;
    IOIdur=zeros(noNotes-1,1);
    
end

IOIdur=zeros(extraNotes-1,1);
if extraNotes~=0 && extraNotes>1
    for i=1:extraNotes-1
        strt1 = note(i).start;
        strt2 = note(i+1).start;
        
        IOIdur(i) = strt2-strt1;
    end
end

    if isempty(IOIdur)~=1
        cnt=cnt+1;
        stdIOIdur=std(IOIdur);
        OutOfRangeStd(cnt)=sum(abs(IOIdur-mean(IOIdur))>stdIOIdur)/(extraNotes-1);
    end
    
    if exist('OutOfRangeStd')~=0
        Feature=mean(OutOfRangeStd);
    else
        Feature=0;
    end
else
    Feature=0;
end
end