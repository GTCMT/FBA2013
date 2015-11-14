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
% across number of notes specified by noNotes variable

function [Feature]=IOIfeatures (note)

noNotes=10;
IOIdur=zeros(noNotes-1,1);
extraNotes=noNotes-floor(size(noNotes)/noNotes);
cnt=0;
for i= 1:noNotes:floor(size(noNotes)/noNotes)
    for j=i:i+noNotes-1
        strt1 = note(j).start;
        strt2 = note(j+1).start;
        
        IOIdur(j) = strt2-strt1;
    end
    stdIOIdur=std(IOIdur);
    cnt=cnt+1;
    OutOfRangeStd(cnt)=sum(abs(IOIdur-mean(IOIdur))>stdIOIdur)/noNotes;
    
end

IOIdur=zeros(extraNotes,1);
if extraNotes~=0 && extraNotes>1
    for i=1:extraNotes-1
        strt1 = note(j).start;
        strt2 = note(j+1).start;
        
        IOIdur(j) = strt2-strt1;
    end
end
    cnt=cnt+1;
    OutOfRangeStd(cnt)=sum(abs(IOIdur-mean(IOIdur))>stdIOIdur)/noNotes;
Feature=mean(OutOfRangeStd);

end