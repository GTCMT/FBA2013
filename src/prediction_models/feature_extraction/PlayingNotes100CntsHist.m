function goodness_measure = PlayingNotes100CntsHist(PitchRead)

PitchInCents(:,1)=PitchRead(:,1);
PitchInCents(:,2)=1200*log2(PitchRead(:,2)/440);

% Folding in a single note
FoldingPInNote=PitchInCents;
for i=1:length(PitchInCents)
    if isnan(PitchInCents(i,2))~=1
        k=abs(mod(PitchInCents(i,2),100));
        FoldingPInNote(i,2)=k;
    else
        FoldingPInNote(i,2)=NaN;
    end
end

stpNote=10;
arrylen=0:(stpNote/2):100;
ffldh1_Note=zeros(length(arrylen),2);
ffldh1_Note(:,1)=arrylen;

ffldh1=zeros(floor(length(arrylen)/2),2);
ffldh_row=(stpNote/2):stpNote:(100-stpNote/2);
ffldh1(:,1)=ffldh_row';

FoldingPInC=PitchInCents;

for i=1:length(FoldingPInC)
    if isnan(FoldingPInC(i,2))~=1
        for j=1:2:length(ffldh1_Note)-1
            if FoldingPInC(i,2)>ffldh1_Note(j,1) && FoldingPInC(i,2)<=ffldh1_Note(j+2,1) 
               ffldh1_Note((j+1),2)=ffldh1_Note((j+1),2)+1;
            end
        end
              
    end
end

ffldh1(:,2)=ffldh1_Note(2:2:length(ffldh1_Note),2);
% figure; plot(ffldh1(:,1),ffldh1(:,2));

[~,locshiftInCent]=max(ffldh1(:,2));
shiftInCent=ffldh1(locshiftInCent,1);

if locshiftInCent-1~=0 && locshiftInCent+1<length(ffldh1)
    goodness_measure=sum(ffldh1(locshiftInCent-1:locshiftInCent+1,2))/sum(ffldh1(:,2));
elseif locshiftInCent-1==0
    goodness_measure=(sum(ffldh1(locshiftInCent:locshiftInCent+1,2))+ffldh1(end,2))/sum(ffldh1(:,2));
else
   goodness_measure=(sum(ffldh1(locshiftInCent-1:locshiftInCent,2))+ffldh1(1,2))/sum(ffldh1(:,2)); 
end



% % % Folding in a single octave
% FoldingPInC=PitchInCents;
% for i=1:length(PitchInCents)
%     if isnan(PitchInCents(i,2))~=1
%         k=abs(mod(PitchInCents(i,2),1200));
%         FoldingPInC(i,2)=k;
%     else
%         FoldingPInC(i,2)=NaN;
%     end
% end
% 
% stp=10;
% arrylen=0:(stp/2):1200;
% ffldh2_comp=zeros(length(arrylen),2);
% ffldh2_comp(:,1)=arrylen;
% 
% ffldh2=zeros(floor(length(arrylen)/2),2);
% ffldh_row=(stp/2):stp:(1200-stp/2);
% ffldh2(:,1)=ffldh_row';
% 
% for i=1:length(FoldingPInC)
%     if isnan(FoldingPInC(i,2))~=1
%         for j=1:2:length(ffldh2_comp)-1
%             if FoldingPInC(i,2)>ffldh2_comp(j,1) && FoldingPInC(i,2)<=ffldh2_comp(j+2,1) 
%                ffldh2_comp((j+1),2)=ffldh2_comp((j+1),2)+1;
%             end
%         end
%               
%     end
% end
% 
% ffldh2(:,2)=ffldh2_comp(2:2:length(ffldh2_comp),2);
% % figure; plot(ffldh2(:,1),ffldh2(:,2))

end