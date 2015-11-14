%% 10 cent bin width histogram of notes folded to 100cents
% AV@GTCMT, 2015
% goodness_measure = PlayingNotes100CntsHist(PitchRead)
% objective: Find accuracy of playing notes across the audio without the score being given
%
% INPUTS
% PitchRead: nx1 float array, pitch values in Hz
%
% OUTPUTS
% goodness_measure: value from 0-1 (1: indicating good, low value indicating bad playing style)

function goodness_measure = PlayingNotes100CntsHist(PitchRead)

% PitchInCents(:,1)=PitchRead(:,1);
PitchInCents=1200*log2(PitchRead/440);

% Folding in a single note
FoldingPInNote=PitchInCents;
for i=1:length(PitchInCents)
    k=abs(mod(PitchInCents(i),100));
    FoldingPInNote(i)=k;
end

stpNote=10; % 10cent bin intervals
arrylen=0:(stpNote/2):100;
ffldh1_Note=zeros(length(arrylen),2);
ffldh1_Note(:,1)=arrylen;

ffldh1=zeros(floor(length(arrylen)/2),2);
ffldh_row=(stpNote/2):stpNote:(100-stpNote/2);
ffldh1(:,1)=ffldh_row';

FoldingPInC=FoldingPInNote;

for i=1:length(FoldingPInC)
    if isnan(FoldingPInC(i))~=1
        for j=1:2:length(ffldh1_Note)-1
            if FoldingPInC(i)>ffldh1_Note(j,1) && FoldingPInC(i)<=ffldh1_Note(j+2,1) 
               ffldh1_Note((j+1),2)=ffldh1_Note((j+1),2)+1;
            end
        end
              
    end
end

ffldh1(:,2)=ffldh1_Note(2:2:length(ffldh1_Note),2);
% figure; plot(ffldh1(:,1),ffldh1(:,2));

[~,locshiftInCent]=max(ffldh1(:,2));
shiftInCent=ffldh1(locshiftInCent,1);

% area 10cents before and after the maximum peak location / total area will
% give the godness_measure

if locshiftInCent-1~=0 && locshiftInCent+1<length(ffldh1)
    goodness_measure=sum(ffldh1(locshiftInCent-1:locshiftInCent+1,2))/sum(ffldh1(:,2));
elseif locshiftInCent-1==0
    goodness_measure=(sum(ffldh1(locshiftInCent:locshiftInCent+1,2))+ffldh1(end,2))/sum(ffldh1(:,2));
else
   goodness_measure=(sum(ffldh1(locshiftInCent-1:locshiftInCent,2))+ffldh1(1,2))/sum(ffldh1(:,2)); 
end

end